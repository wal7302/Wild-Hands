class_name DiscardPileVisual
extends Node2D

var pile_size := Vector2(72, 104)
var pile_color := Color("#E9CFA8")
var border_color := Color("#7A1E2C")
var shadow_color := Color(0, 0, 0, 0.18)
var highlight_color := Color(1, 1, 1, 0.35)

func _ready():
	queue_redraw()

func _draw():
	draw_rect(Rect2(Vector2(5, 6), pile_size), shadow_color, true)
	draw_rect(Rect2(Vector2.ZERO, pile_size), pile_color, true)
	draw_rect(Rect2(Vector2.ZERO, pile_size), border_color, false, 3)
	draw_line(Vector2(8, 10), Vector2(64, 10), highlight_color, 1)
	draw_line(Vector2(8, 94), Vector2(64, 94), Color("#D8A441"), 1)