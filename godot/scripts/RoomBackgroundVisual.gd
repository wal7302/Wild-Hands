class_name RoomBackgroundVisual
extends Node2D

var cream := Color("#F4E7D3")
var room_gold := Color("#F7E0BD")
var room_shadow := Color("#D6AE75")

func _ready():
	queue_redraw()

func _draw():
	draw_rect(Rect2(0, 0, 390, 844), cream, true)
	draw_rect(Rect2(24, 151, 354, 560), room_shadow, true)
	draw_rect(Rect2(18, 145, 354, 560), room_gold, true)

	for i: int in range(8):
		var y: float = 160.0 + float(i * 64)
		draw_line(Vector2(24, y), Vector2(366, y), Color(1, 1, 1, 0.08), 1)