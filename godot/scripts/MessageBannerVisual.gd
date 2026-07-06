class_name MessageBannerVisual
extends Node2D

var banner_size := Vector2(320, 42)
var bg_color := Color("#FFF4DF")
var border_color := Color("#7A1E2C")
var shadow_color := Color(0, 0, 0, 0.16)
var text_color := Color("#7A1E2C")
var gold := Color("#D8A441")

var message := "Grace deals one card at a time."

func set_message(new_message: String):
	message = new_message
	queue_redraw()

func _ready():
	queue_redraw()

func _draw():
	draw_rect(Rect2(Vector2(4, 5), banner_size), shadow_color, true)
	draw_rect(Rect2(Vector2.ZERO, banner_size), bg_color, true)
	draw_rect(Rect2(Vector2.ZERO, banner_size), border_color, false, 2)
	draw_line(Vector2(10, 5), Vector2(310, 5), Color(1, 1, 1, 0.45), 1)
	draw_line(Vector2(12, 37), Vector2(308, 37), gold, 1)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(14, 27),
		message,
		HORIZONTAL_ALIGNMENT_LEFT,
		292,
		16,
		text_color
	)