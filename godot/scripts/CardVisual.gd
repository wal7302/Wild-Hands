class_name CardVisual
extends Node2D

signal selected(card)
signal deselected(card)

const CARD_BACK_PATH := "res://assets/cards/card_back.png"
const WILD_BADGE_PATH := "res://assets/cards/wild_badge.png"
const CARD_FACE_DIRECTORY := "res://assets/cards/faces/"

var card_id := ""
var rank := ""
var suit := ""
var is_wild := false
var is_face_down := false
var is_selected := false
var is_interactable := true

var card_size := Vector2(82, 118)
var original_position := Vector2.ZERO
var original_rotation := 0.0

var hit_area: Area2D
var collision: CollisionShape2D
var active_tween: Tween

var face_texture: Texture2D
var back_texture: Texture2D
var wild_badge_texture: Texture2D

var ivory := Color("#FFF9EC")
var ivory_light := Color("#FFFEF8")
var cranberry := Color("#7A1E2C")
var cranberry_dark := Color("#481019")
var gold := Color("#D8A441")
var gold_light := Color("#F1CC78")
var red_suit := Color("#A6192E")
var black_suit := Color("#211813")

func _ready():
	create_hit_area()
	load_shared_textures()
	load_face_texture()
	queue_redraw()

func create_hit_area():
	hit_area = Area2D.new()
	hit_area.input_pickable = true
	add_child(hit_area)

	collision = CollisionShape2D.new()

	var shape := RectangleShape2D.new()
	shape.size = card_size

	collision.shape = shape
	collision.position = card_size / 2.0
	hit_area.add_child(collision)

	hit_area.input_event.connect(_on_input_event)

func load_shared_textures():
	if ResourceLoader.exists(CARD_BACK_PATH):
		back_texture = load(CARD_BACK_PATH)

	if ResourceLoader.exists(WILD_BADGE_PATH):
		wild_badge_texture = load(WILD_BADGE_PATH)

func load_face_texture():
	face_texture = null

	if card_id.is_empty():
		return

	var face_path: String = CARD_FACE_DIRECTORY + card_id + ".png"

	if ResourceLoader.exists(face_path):
		face_texture = load(face_path)

func configure(data: Dictionary):
	card_id = data.get("id", "")
	rank = data.get("rank", "")
	suit = data.get("suit", "")
	is_wild = data.get("wild", false)
	is_face_down = data.get("face_down", false)

	load_face_texture()
	queue_redraw()

func set_card_face(
	new_rank: String,
	new_suit: String,
	wild: bool = false
):
	card_id = "%s%s" % [new_rank, new_suit]
	rank = new_rank
	suit = new_suit
	is_wild = wild
	is_face_down = false

	load_face_texture()
	queue_redraw()

func set_card_back():
	is_face_down = true
	queue_redraw()

func flip_to_face():
	if not is_face_down:
		return

	kill_active_tween()

	active_tween = CardAnimator.flip_card(
		self,
		func():
			is_face_down = false
			queue_redraw()
	)

func flip_to_back():
	if is_face_down:
		return

	kill_active_tween()

	active_tween = CardAnimator.flip_card(
		self,
		func():
			is_face_down = true
			queue_redraw()
	)

func set_interactable(value: bool):
	is_interactable = value

	if hit_area != null:
		hit_area.input_pickable = value

	if not value:
		is_selected = false

	queue_redraw()

func kill_active_tween():
	if active_tween != null and active_tween.is_valid():
		active_tween.kill()

	active_tween = null

func move_to(
	target_position: Vector2,
	target_rotation: float,
	duration: float = 0.28,
	delay: float = 0.0
):
	kill_active_tween()

	original_position = target_position
	original_rotation = target_rotation

	active_tween = CardAnimator.move_card(
		self,
		target_position,
		target_rotation,
		duration,
		delay
	)

func deal_to(
	target_position: Vector2,
	target_rotation: float,
	duration: float = 0.42,
	delay: float = 0.0,
	deal_variation: Vector2 = Vector2.ZERO
):
	kill_active_tween()

	original_position = target_position
	original_rotation = target_rotation

	active_tween = CardAnimator.deal_card(
		self,
		target_position,
		target_rotation,
		duration,
		delay,
		deal_variation
	)

func fly_to(
	target_position: Vector2,
	target_rotation: float,
	duration: float = 0.42
):
	kill_active_tween()

	active_tween = CardAnimator.discard_card(
		self,
		target_position,
		target_rotation,
		duration
	)

func pulse():
	kill_active_tween()
	active_tween = CardAnimator.pulse_card(self)

func select():
	if not is_interactable or is_selected:
		return

	is_selected = true
	z_index += 50

	kill_active_tween()

	var selected_position := original_position + Vector2(0, -32)

	active_tween = CardAnimator.select_card(
		self,
		selected_position,
		original_rotation * 0.35
	)

	selected.emit(self)
	queue_redraw()

func deselect():
	if not is_selected:
		return

	is_selected = false
	z_index -= 50

	kill_active_tween()

	active_tween = CardAnimator.deselect_card(
		self,
		original_position,
		original_rotation
	)

	deselected.emit(self)
	queue_redraw()

func force_deselect():
	if is_selected:
		z_index -= 50

	is_selected = false
	scale = Vector2.ONE
	queue_redraw()

func _on_input_event(_viewport, event, _shape_idx):
	if not is_interactable:
		return

	if event is InputEventMouseButton and event.pressed:
		if is_selected:
			deselect()
		else:
			select()

func _draw():
	draw_card_shadow()

	if is_face_down:
		if back_texture != null:
			draw_texture_rect(
				back_texture,
				Rect2(Vector2.ZERO, card_size),
				false
			)
		else:
			draw_fallback_card_back()
	else:
		if face_texture != null:
			draw_texture_rect(
				face_texture,
				Rect2(Vector2.ZERO, card_size),
				false
			)
		else:
			draw_fallback_card_face()

	if is_wild and wild_badge_texture != null:
		draw_texture_rect(
			wild_badge_texture,
			Rect2(14, 89, 54, 20),
			false
		)

	if is_selected:
		draw_selection_border()

func draw_card_shadow():
	var shadow_offset := Vector2(6, 8)

	if is_selected:
		shadow_offset = Vector2(9, 13)

	var shadow_style := StyleBoxFlat.new()
	shadow_style.bg_color = Color(0, 0, 0, 0.31)
	shadow_style.set_corner_radius_all(10)

	draw_style_box(
		shadow_style,
		Rect2(shadow_offset, card_size)
	)

func draw_selection_border():
	var style := StyleBoxFlat.new()

	style.bg_color = Color(0, 0, 0, 0)
	style.border_color = gold_light
	style.set_border_width_all(4)
	style.set_corner_radius_all(11)

	draw_style_box(
		style,
		Rect2(
			Vector2(-5, -5),
			card_size + Vector2(10, 10)
		)
	)

func draw_fallback_card_back():
	var back_style := StyleBoxFlat.new()

	back_style.bg_color = cranberry_dark
	back_style.border_color = gold
	back_style.set_border_width_all(3)
	back_style.set_corner_radius_all(9)

	draw_style_box(
		back_style,
		Rect2(Vector2.ZERO, card_size)
	)

	var inner_style := StyleBoxFlat.new()

	inner_style.bg_color = cranberry
	inner_style.border_color = gold_light
	inner_style.set_border_width_all(1)
	inner_style.set_corner_radius_all(6)

	draw_style_box(
		inner_style,
		Rect2(8, 8, 66, 102)
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(27, 72),
		"◆",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		40,
		gold_light
	)

func draw_fallback_card_face():
	var face_style := StyleBoxFlat.new()

	face_style.bg_color = ivory
	face_style.border_color = cranberry_dark
	face_style.set_border_width_all(2)
	face_style.set_corner_radius_all(9)

	draw_style_box(
		face_style,
		Rect2(Vector2.ZERO, card_size)
	)

	var inset_style := StyleBoxFlat.new()

	inset_style.bg_color = ivory_light
	inset_style.border_color = Color(0.48, 0.2, 0.13, 0.18)
	inset_style.set_border_width_all(1)
	inset_style.set_corner_radius_all(6)

	draw_style_box(
		inset_style,
		Rect2(5, 5, 72, 108)
	)

	var suit_color: Color = (
		red_suit
		if suit in ["♥", "♦"]
		else black_suit
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(9, 27),
		rank,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		23,
		suit_color
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(10, 48),
		suit,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		19,
		suit_color
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(25, 79),
		suit,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		45,
		suit_color
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(61, 108),
		rank,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		17,
		suit_color
	)

	if is_wild and wild_badge_texture == null:
		var wild_style := StyleBoxFlat.new()

		wild_style.bg_color = cranberry
		wild_style.border_color = gold_light
		wild_style.set_border_width_all(1)
		wild_style.set_corner_radius_all(5)

		draw_style_box(
			wild_style,
			Rect2(14, 89, 54, 20)
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(20, 104),
			"WILD",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			12,
			gold_light
		)