class_name RoomBackgroundVisual
extends Node2D

const BACKGROUND_PATH := "res://assets/environment/graces_living_room.png"
const TARGET_SIZE := Vector2(390, 844)

func _ready() -> void:
	if !ResourceLoader.exists(BACKGROUND_PATH):
		push_error("Missing: " + BACKGROUND_PATH)
		return

	var texture: Texture2D = load(BACKGROUND_PATH)

	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false

	var tex_size: Vector2 = texture.get_size()

	var scale_factor: float = max(
		TARGET_SIZE.x / tex_size.x,
		TARGET_SIZE.y / tex_size.y
	) * 0.90

	sprite.scale = Vector2.ONE * scale_factor

	var final_size: Vector2 = tex_size * scale_factor
	sprite.position = (TARGET_SIZE - final_size) * 0.5

	add_child(sprite)