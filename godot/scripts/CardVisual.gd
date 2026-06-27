class_name CardVisual
extends Control

var rank := ""
var suit := ""
var is_wild := false
var face_up := false

func _ready():
	size = Vector2(58, 82)
	queue_redraw()

func set_card_back():
	face_up = false
	queue_redraw()

func set_card_face(new_rank: String, new_suit: String, wild: bool = false):
	rank = new_rank
	suit = new_suit
	is_wild = wild
	face_up = true
	queue_redraw()

func _draw():
	var rect := Rect2(Vector2.ZERO, size)

	draw_rect(rect, Color("#FFFDF7"), true)
	draw_rect(rect, Color("#7A1E2C"), false, 3)

	if face_up:
		var suit_color = Color("#B21E35") if suit in ["♥", "♦"] else Color("#1E1A18")
		draw_string(get_theme_default_font(), Vector2(8, 22), rank, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, suit_color)
		draw_string(get_theme_default_font(), Vector2(20, 52), suit, HORIZONTAL_ALIGNMENT_LEFT, -1, 28, suit_color)

		if is_wild:
			draw_rect(Rect2(12, 60, 34, 14), Color("#7A1E2C"), true)
			draw_string(get_theme_default_font(), Vector2(15, 72), "WILD", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Color("#D8A441"))
	else:
		draw_string(get_theme_default_font(), Vector2(17, 52), "◆", HORIZONTAL_ALIGNMENT_LEFT, -1, 32, Color("#7A1E2C"))
