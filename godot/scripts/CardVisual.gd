class_name CardVisual
extends Node2D


signal selected(card)
signal deselected(card)


const CARD_BACK_PATH := "res://assets/cards/backs/card_back.png"
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

var selection_glow_phase: float = 0.0
var selection_glow_strength: float = 0.0

var face_texture: Texture2D
var back_texture: Texture2D
var wild_badge_texture: Texture2D


var ivory := Color("#FFF9EC")
var ivory_light := Color("#FFFEF8")
var ivory_shadow := Color("#E9DDC9")

var cranberry := Color("#7A1E2C")
var cranberry_dark := Color("#481019")
var cranberry_light := Color("#A83A4B")

var gold := Color("#D8A441")
var gold_light := Color("#F1CC78")
var gold_soft := Color("#E7BD62")

var red_suit := Color("#A6192E")
var black_suit := Color("#211813")

var edge_dark := Color("#2E1715")
var inner_edge := Color(0.42, 0.20, 0.13, 0.24)


func _ready() -> void:
	create_hit_area()
	load_shared_textures()
	load_face_texture()

	set_process(true)

	queue_redraw()


func _process(delta: float) -> void:
	var target_strength: float = (
		1.0
		if is_selected
		else 0.0
	)

	selection_glow_strength = move_toward(
		selection_glow_strength,
		target_strength,
		delta * 7.0
	)

	if selection_glow_strength > 0.001:
		selection_glow_phase = fmod(
			selection_glow_phase + delta * 2.6,
			TAU
		)

		queue_redraw()
	elif selection_glow_strength != 0.0:
		selection_glow_strength = 0.0
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

	var face_path := CARD_FACE_DIRECTORY + card_id + ".png"

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

	# Capture the card's current resting location before lifting it.
	original_position = position
	original_rotation = rotation_degrees

	is_selected = true
	z_index += 50

	kill_active_tween()

	var selected_position: Vector2 = (
		original_position
		+ Vector2(0.0, -32.0)
	)

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
		draw_card_back()
	else:
		draw_card_face()

	draw_outer_card_frame()

	if is_wild and not is_face_down:
		draw_wild_badge()

	if not is_interactable:
		draw_disabled_overlay()

	if is_selected:
		draw_selection_glow()
		draw_selection_border()


func draw_card_shadow():
	var shadow_offset := Vector2(4, 6)
	var shadow_alpha := 0.26

	if is_selected:
		shadow_offset = Vector2(7, 11)
		shadow_alpha = 0.38

	var soft_shadow := StyleBoxFlat.new()
	soft_shadow.bg_color = Color(0, 0, 0, shadow_alpha * 0.45)
	soft_shadow.set_corner_radius_all(12)

	draw_style_box(
		soft_shadow,
		Rect2(
			shadow_offset + Vector2(2, 3),
			card_size
		)
	)

	var main_shadow := StyleBoxFlat.new()
	main_shadow.bg_color = Color(0, 0, 0, shadow_alpha)
	main_shadow.set_corner_radius_all(11)

	draw_style_box(
		main_shadow,
		Rect2(shadow_offset, card_size)
	)


func draw_card_back():
	if back_texture != null:
		draw_texture_rect(
			back_texture,
			Rect2(Vector2.ZERO, card_size),
			false
		)
	else:
		draw_fallback_card_back()


func draw_card_face():
	if face_texture != null:
		draw_texture_rect(
			face_texture,
			Rect2(Vector2.ZERO, card_size),
			false
		)
	else:
		draw_fallback_card_face()


func draw_outer_card_frame():
	var outer_frame := StyleBoxFlat.new()

	outer_frame.bg_color = Color(0, 0, 0, 0)
	outer_frame.border_color = (
		gold_soft
		if is_wild and not is_face_down
		else edge_dark
	)

	outer_frame.set_border_width_all(
		3 if is_wild and not is_face_down else 2
	)

	outer_frame.set_corner_radius_all(10)

	draw_style_box(
		outer_frame,
		Rect2(Vector2.ZERO, card_size)
	)

	var highlight := StyleBoxFlat.new()

	highlight.bg_color = Color(0, 0, 0, 0)
	highlight.border_color = Color(1, 1, 1, 0.22)
	highlight.border_width_top = 1
	highlight.border_width_left = 1
	highlight.set_corner_radius_all(9)

	draw_style_box(
		highlight,
		Rect2(2, 2, card_size.x - 4, card_size.y - 4)
	)


func draw_selection_glow() -> void:
	var pulse_amount: float = (
		0.5
		+ sin(selection_glow_phase) * 0.5
	)

	var glow_alpha: float = lerpf(
		0.08,
		0.17,
		pulse_amount
	) * selection_glow_strength

	var border_alpha: float = lerpf(
		0.18,
		0.34,
		pulse_amount
	) * selection_glow_strength

	var glow_expansion: float = lerpf(
		7.0,
		11.0,
		pulse_amount
	)

	var outer_glow := StyleBoxFlat.new()

	outer_glow.bg_color = Color(
		gold_light,
		glow_alpha * 0.45
	)

	outer_glow.border_color = Color(
		gold_light,
		glow_alpha
	)

	outer_glow.set_border_width_all(7)
	outer_glow.set_corner_radius_all(17)

	draw_style_box(
		outer_glow,
		Rect2(
			Vector2(
				-glow_expansion,
				-glow_expansion
			),
			card_size
			+ Vector2(
				glow_expansion * 2.0,
				glow_expansion * 2.0
			)
		)
	)

	var inner_glow := StyleBoxFlat.new()

	inner_glow.bg_color = Color(
		gold_soft,
		glow_alpha * 0.30
	)

	inner_glow.border_color = Color(
		gold_light,
		border_alpha
	)

	inner_glow.set_border_width_all(4)
	inner_glow.set_corner_radius_all(14)

	draw_style_box(
		inner_glow,
		Rect2(
			Vector2(-5, -5),
			card_size + Vector2(10, 10)
		)
	)


func draw_selection_border() -> void:
	var pulse_amount: float = (
		0.5
		+ sin(selection_glow_phase) * 0.5
	)

	var border_style := StyleBoxFlat.new()

	border_style.bg_color = Color.TRANSPARENT

	border_style.border_color = Color(
		gold_light,
		lerpf(
			0.82,
			1.0,
			pulse_amount
		)
	)

	border_style.set_border_width_all(3)
	border_style.set_corner_radius_all(12)

	draw_style_box(
		border_style,
		Rect2(
			Vector2(-3, -3),
			card_size + Vector2(6, 6)
		)
	)

	var highlight := StyleBoxFlat.new()

	highlight.bg_color = Color.TRANSPARENT

	highlight.border_color = Color(
		1.0,
		0.91,
		0.60,
		lerpf(
			0.26,
			0.52,
			pulse_amount
		)
	)

	highlight.border_width_top = 2
	highlight.border_width_left = 2
	highlight.set_corner_radius_all(11)

	draw_style_box(
		highlight,
		Rect2(
			Vector2(-1, -1),
			card_size + Vector2(2, 2)
		)
	)


func draw_disabled_overlay():
	var overlay := StyleBoxFlat.new()

	overlay.bg_color = Color(0.12, 0.10, 0.09, 0.12)
	overlay.set_corner_radius_all(10)

	draw_style_box(
		overlay,
		Rect2(Vector2.ZERO, card_size)
	)


func draw_fallback_card_back():
	var outer_style := StyleBoxFlat.new()

	outer_style.bg_color = cranberry_dark
	outer_style.border_color = gold
	outer_style.set_border_width_all(2)
	outer_style.set_corner_radius_all(10)

	draw_style_box(
		outer_style,
		Rect2(Vector2.ZERO, card_size)
	)

	var middle_style := StyleBoxFlat.new()

	middle_style.bg_color = cranberry
	middle_style.border_color = gold_light
	middle_style.set_border_width_all(1)
	middle_style.set_corner_radius_all(7)

	draw_style_box(
		middle_style,
		Rect2(7, 7, 68, 104)
	)

	var inner_style := StyleBoxFlat.new()

	inner_style.bg_color = cranberry_dark
	inner_style.border_color = Color(gold_light, 0.72)
	inner_style.set_border_width_all(1)
	inner_style.set_corner_radius_all(5)

	draw_style_box(
		inner_style,
		Rect2(12, 12, 58, 94)
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(25, 75),
		"◆",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		42,
		gold_light
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(34, 62),
		"◆",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		20,
		cranberry_light
	)


func draw_fallback_card_face():
	var face_style := StyleBoxFlat.new()

	face_style.bg_color = ivory
	face_style.border_color = edge_dark
	face_style.set_border_width_all(2)
	face_style.set_corner_radius_all(10)

	draw_style_box(
		face_style,
		Rect2(Vector2.ZERO, card_size)
	)

	var inset_style := StyleBoxFlat.new()

	inset_style.bg_color = ivory_light
	inset_style.border_color = inner_edge
	inset_style.set_border_width_all(1)
	inset_style.set_corner_radius_all(7)

	draw_style_box(
		inset_style,
		Rect2(5, 5, 72, 108)
	)

	var bottom_shade := StyleBoxFlat.new()

	bottom_shade.bg_color = Color(ivory_shadow, 0.24)
	bottom_shade.set_corner_radius_all(6)

	draw_style_box(
		bottom_shade,
		Rect2(6, 91, 70, 21)
	)

	var suit_color := (
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
		22,
		suit_color
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(10, 47),
		suit,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		18,
		suit_color
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(24, 80),
		suit,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		46,
		suit_color
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(59, 108),
		rank,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		17,
		suit_color
	)


func draw_wild_badge():
	var badge_rect := Rect2(14, 90, 54, 19)

	var badge_shadow := StyleBoxFlat.new()

	badge_shadow.bg_color = Color(0, 0, 0, 0.25)
	badge_shadow.set_corner_radius_all(6)

	draw_style_box(
		badge_shadow,
		Rect2(
			badge_rect.position + Vector2(2, 3),
			badge_rect.size
		)
	)

	if wild_badge_texture != null:
		draw_texture_rect(
			wild_badge_texture,
			badge_rect,
			false
		)
		return

	var badge_style := StyleBoxFlat.new()

	badge_style.bg_color = cranberry
	badge_style.border_color = gold_light
	badge_style.set_border_width_all(1)
	badge_style.set_corner_radius_all(6)

	draw_style_box(
		badge_style,
		badge_rect
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(23, 104),
		"WILD",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		12,
		gold_light
	)