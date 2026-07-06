class_name CardVisual
extends Node2D

signal selected(card)
signal deselected(card)

var card_id := ""
var rank := ""
var suit := ""
var is_wild := false
var is_face_down := false
var is_selected := false
var is_interactable := true

var card_size := Vector2(72, 104)
var original_position := Vector2.ZERO

var hit_area: Area2D
var collision: CollisionShape2D
var active_tween: Tween

var card_white := Color("#FFFDF7")
var cranberry := Color("#7A1E2C")
var walnut := Color("#6B3F24")
var walnut_dark := Color("#3B2114")
var cream := Color("#F4E7D3")
var gold := Color("#D8A441")
var red_suit := Color("#B21E35")
var black_suit := Color("#1E1A18")
var shadow_color := Color(0, 0, 0, 0.25)

func _ready():
	create_hit_area()
	queue_redraw()

func create_hit_area():
	hit_area = Area2D.new()
	hit_area.input_pickable = true
	add_child(hit_area)

	collision = CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = card_size
	collision.shape = shape
	collision.position = card_size / 2
	hit_area.add_child(collision)

	hit_area.input_event.connect(_on_input_event)

func configure(data: Dictionary):
	card_id = data.get("id", "")
	rank = data.get("rank", "")
	suit = data.get("suit", "")
	is_wild = data.get("wild", false)
	is_face_down = data.get("face_down", false)
	queue_redraw()

func set_card_face(new_rank: String, new_suit: String, wild: bool = false):
	card_id = "%s%s" % [new_rank, new_suit]
	rank = new_rank
	suit = new_suit
	is_wild = wild
	is_face_down = false
	queue_redraw()

func set_card_back():
	is_face_down = true
	queue_redraw()

func set_interactable(value: bool):
	is_interactable = value
	if hit_area != null:
		hit_area.input_pickable = value

	if not value:
		is_selected = false

	queue_redraw()

func move_to(target_position: Vector2, target_rotation: float, duration: float = 0.28, delay: float = 0.0):
	if active_tween != null:
		active_tween.kill()

	original_position = target_position

	active_tween = create_tween()
	active_tween.set_trans(Tween.TRANS_CUBIC)
	active_tween.set_ease(Tween.EASE_OUT)
	active_tween.tween_property(self, "position", target_position, duration).set_delay(delay)
	active_tween.parallel().tween_property(self, "rotation_degrees", target_rotation, duration).set_delay(delay)

func fly_to(target_position: Vector2, target_rotation: float, duration: float = 0.35):
	if active_tween != null:
		active_tween.kill()

	active_tween = create_tween()
	active_tween.set_trans(Tween.TRANS_BACK)
	active_tween.set_ease(Tween.EASE_OUT)
	active_tween.tween_property(self, "position", target_position, duration)
	active_tween.parallel().tween_property(self, "rotation_degrees", target_rotation, duration)
	active_tween.parallel().tween_property(self, "scale", Vector2(1.04, 1.04), duration * 0.45)
	active_tween.tween_property(self, "scale", Vector2.ONE, duration * 0.35)

func select():
	if not is_interactable:
		return

	if is_selected:
		return

	is_selected = true
	original_position = position

	if active_tween != null:
		active_tween.kill()

	active_tween = create_tween()
	active_tween.set_trans(Tween.TRANS_BACK)
	active_tween.set_ease(Tween.EASE_OUT)
	active_tween.tween_property(self, "position:y", original_position.y - 24, 0.14)

	selected.emit(self)
	queue_redraw()

func deselect():
	if not is_selected:
		return

	is_selected = false

	if active_tween != null:
		active_tween.kill()

	active_tween = create_tween()
	active_tween.set_trans(Tween.TRANS_CUBIC)
	active_tween.set_ease(Tween.EASE_OUT)
	active_tween.tween_property(self, "position", original_position, 0.14)

	deselected.emit(self)
	queue_redraw()

func force_deselect():
	is_selected = false
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
	var card_rect := Rect2(Vector2.ZERO, card_size)
	var shadow_rect := Rect2(Vector2(4, 5), card_size)

	draw_rect(shadow_rect, shadow_color, true)

	if is_face_down:
		draw_card_back(card_rect)
	else:
		draw_card_face(card_rect)

	if is_selected:
		draw_rect(Rect2(Vector2(-4, -4), card_size + Vector2(8, 8)), gold, false, 3)

func draw_card_back(card_rect: Rect2):
	draw_rect(card_rect, walnut, true)
	draw_rect(card_rect, walnut_dark, false, 3)
	draw_rect(Rect2(8, 8, 56, 88), cranberry, false, 2)
	draw_string(ThemeDB.fallback_font, Vector2(26, 60), "◆", HORIZONTAL_ALIGNMENT_LEFT, -1, 34, cream)

func draw_card_face(card_rect: Rect2):
	draw_rect(card_rect, card_white, true)
	draw_rect(card_rect, cranberry, false, 3)

	var suit_color := red_suit if suit in ["♥", "♦"] else black_suit

	draw_string(ThemeDB.fallback_font, Vector2(8, 24), rank, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, suit_color)
	draw_string(ThemeDB.fallback_font, Vector2(24, 62), suit, HORIZONTAL_ALIGNMENT_LEFT, -1, 34, suit_color)

	if is_wild:
		draw_rect(Rect2(13, 80, 46, 16), cranberry, true)
		draw_string(ThemeDB.fallback_font, Vector2(17, 93), "WILD", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, gold)