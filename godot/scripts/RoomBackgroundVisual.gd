class_name RoomBackgroundVisual
extends Node2D

const BACKGROUND_PATH := "res://assets/environment/graces_living_room.png"
const LIGHTING_PATH := "res://assets/environment/warm_lighting_overlay.png"
const VIGNETTE_PATH := "res://assets/environment/ambient_vignette.png"

const TARGET_SIZE := Vector2(390, 844)

var wall_base := Color("#E8D0AF")
var wall_light := Color("#F8EAD5")
var trim_dark := Color("#6B3F24")
var trim_light := Color("#B77B42")
var gold := Color("#D8A441")

func _ready():
	if ResourceLoader.exists(BACKGROUND_PATH):
		add_fitted_sprite(BACKGROUND_PATH, 0)
	else:
		queue_redraw()

	if ResourceLoader.exists(LIGHTING_PATH):
		add_fitted_sprite(LIGHTING_PATH, 1)

	if ResourceLoader.exists(VIGNETTE_PATH):
		add_fitted_sprite(VIGNETTE_PATH, 2)

func add_fitted_sprite(texture_path: String, layer: int):
	var texture: Texture2D = load(texture_path)
	var sprite := Sprite2D.new()

	sprite.texture = texture
	sprite.centered = false
	sprite.position = Vector2.ZERO
	sprite.z_index = layer

	var texture_size: Vector2 = texture.get_size()

	if texture_size.x > 0.0 and texture_size.y > 0.0:
		sprite.scale = Vector2(
			TARGET_SIZE.x / texture_size.x,
			TARGET_SIZE.y / texture_size.y
		)

	add_child(sprite)

func _draw():
	draw_rect(Rect2(Vector2.ZERO, TARGET_SIZE), wall_base, true)

	draw_rect(
		Rect2(22, 146, 352, 560),
		Color(0, 0, 0, 0.16),
		true
	)

	draw_rect(
		Rect2(16, 140, 358, 560),
		wall_light,
		true
	)

	draw_rect(
		Rect2(16, 140, 358, 560),
		trim_dark,
		false,
		4
	)

	draw_rect(
		Rect2(28, 157, 334, 528),
		Color("#F1DDBF"),
		true
	)

	draw_rect(
		Rect2(28, 157, 334, 528),
		trim_light,
		false,
		2
	)

	for row: int in range(4):
		var y: float = 175.0 + float(row * 118)

		draw_rect(
			Rect2(40, y, 140, 92),
			Color("#F7E7CE"),
			true
		)

		draw_rect(
			Rect2(40, y, 140, 92),
			Color("#CFA06C"),
			false,
			2
		)

		draw_rect(
			Rect2(210, y, 140, 92),
			Color("#F7E7CE"),
			true
		)

		draw_rect(
			Rect2(210, y, 140, 92),
			Color("#CFA06C"),
			false,
			2
		)

	draw_rect(Rect2(0, 124, 390, 16), trim_dark, true)
	draw_rect(Rect2(0, 124, 390, 4), gold, true)
	draw_rect(Rect2(0, 700, 390, 144), Color("#4A2A1B"), true)

	for i: int in range(9):
		var x: float = float(i) * 48.0

		draw_line(
			Vector2(x, 700),
			Vector2(x + 24, 844),
			Color(0.18, 0.08, 0.04, 0.25),
			2
		)