class_name WoodTableVisual
extends Node2D

const TABLE_TEXTURE_PATH := "res://assets/environment/walnut_game_table.png"
const TABLE_SHADOW_PATH := "res://assets/environment/table_shadow.png"

const TABLE_TEXTURE_SIZE := Vector2(372, 510)
const TABLE_TEXTURE_POSITION := Vector2(9, 190)

var walnut_base := Color("#5A321E")
var walnut_mid := Color("#754426")
var walnut_light := Color("#9A643B")
var walnut_dark := Color("#2B160D")
var gold := Color("#D8A441")

var table_polygon := PackedVector2Array([
	Vector2(42, 198),
	Vector2(348, 198),
	Vector2(378, 390),
	Vector2(336, 691),
	Vector2(54, 691),
	Vector2(12, 390)
])

var inner_polygon := PackedVector2Array([
	Vector2(56, 216),
	Vector2(334, 216),
	Vector2(358, 390),
	Vector2(321, 672),
	Vector2(69, 672),
	Vector2(32, 390)
])

var shadow_polygon := PackedVector2Array([
	Vector2(51, 213),
	Vector2(357, 213),
	Vector2(389, 404),
	Vector2(348, 708),
	Vector2(65, 708),
	Vector2(23, 404)
])

func _ready():
	if ResourceLoader.exists(TABLE_SHADOW_PATH):
		add_table_sprite(TABLE_SHADOW_PATH, -1)

	if ResourceLoader.exists(TABLE_TEXTURE_PATH):
		add_table_sprite(TABLE_TEXTURE_PATH, 0)
	else:
		queue_redraw()

func add_table_sprite(texture_path: String, layer: int):
	var texture: Texture2D = load(texture_path)
	var sprite := Sprite2D.new()

	sprite.texture = texture
	sprite.centered = false
	sprite.position = TABLE_TEXTURE_POSITION
	sprite.z_index = layer

	var texture_size: Vector2 = texture.get_size()

	if texture_size.x > 0.0 and texture_size.y > 0.0:
		sprite.scale = Vector2(
			TABLE_TEXTURE_SIZE.x / texture_size.x,
			TABLE_TEXTURE_SIZE.y / texture_size.y
		)

	add_child(sprite)

func _draw():
	draw_colored_polygon(
		shadow_polygon,
		Color(0, 0, 0, 0.38)
	)

	draw_colored_polygon(
		table_polygon,
		walnut_dark
	)

	draw_colored_polygon(
		inner_polygon,
		walnut_base
	)

	var inner_glow := PackedVector2Array([
		Vector2(69, 232),
		Vector2(321, 232),
		Vector2(340, 390),
		Vector2(306, 651),
		Vector2(84, 651),
		Vector2(50, 390)
	])

	draw_colored_polygon(
		inner_glow,
		walnut_mid
	)

	for i: int in range(9):
		var y: float = 255.0 + float(i * 43)

		draw_line(
			Vector2(57, y),
			Vector2(333, y - 4),
			Color(0.19, 0.08, 0.035, 0.34),
			3
		)

		draw_line(
			Vector2(60, y + 3),
			Vector2(330, y - 1),
			Color(0.82, 0.51, 0.28, 0.16),
			1
		)

	for i: int in range(inner_polygon.size()):
		var start: Vector2 = inner_polygon[i]
		var finish: Vector2 = inner_polygon[
			(i + 1) % inner_polygon.size()
		]

		draw_line(start, finish, gold, 2)

	for i: int in range(table_polygon.size()):
		var start: Vector2 = table_polygon[i]
		var finish: Vector2 = table_polygon[
			(i + 1) % table_polygon.size()
		]

		draw_line(start, finish, walnut_dark, 12)
		draw_line(start, finish, walnut_light, 3)