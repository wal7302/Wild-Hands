class_name WoodTableVisual
extends Node2D

var walnut := Color("#6B3F24")
var walnut_light := Color("#8A5735")
var walnut_dark := Color("#3B2114")

var table_polygon := PackedVector2Array([
	Vector2(68, 215),
	Vector2(322, 215),
	Vector2(350, 395),
	Vector2(312, 635),
	Vector2(78, 635),
	Vector2(40, 395)
])

var shadow_polygon := PackedVector2Array([
	Vector2(76, 225),
	Vector2(330, 225),
	Vector2(358, 405),
	Vector2(320, 645),
	Vector2(86, 645),
	Vector2(48, 405)
])

func _ready():
	queue_redraw()

func _draw():
	draw_colored_polygon(shadow_polygon, Color(0, 0, 0, 0.18))
	draw_colored_polygon(table_polygon, walnut)

	for i: int in range(table_polygon.size()):
		var start: Vector2 = table_polygon[i]
		var finish: Vector2 = table_polygon[(i + 1) % table_polygon.size()]
		draw_line(start, finish, walnut_light, 3)
		draw_line(start, finish, walnut_dark, 10)

	for i: int in range(6):
		draw_line(
			Vector2(80, 255 + (i * 55)),
			Vector2(310, 245 + (i * 57)),
			Color(0.24, 0.12, 0.06, 0.22),
			2
		)