class_name RoomBackgroundVisual
extends Node2D

const BACKGROUND_PATH: String = (
	"res://assets/environment/graces_living_room.png"
)

const TARGET_SIZE: Vector2 = Vector2(390.0, 844.0)

# Increase this to make the table/background appear closer.
const BACKGROUND_ZOOM: float = 1.08

# Positive Y moves the background down.
# Negative Y moves it up.
const BACKGROUND_OFFSET: Vector2 = Vector2(0.0, 8.0)


func _ready() -> void:
	if not ResourceLoader.exists(BACKGROUND_PATH):
		push_error("Missing: " + BACKGROUND_PATH)
		return

	var texture: Texture2D = load(BACKGROUND_PATH) as Texture2D

	if texture == null:
		push_error("Unable to load: " + BACKGROUND_PATH)
		return

	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false

	var texture_size: Vector2 = texture.get_size()

	var cover_scale: float = maxf(
		TARGET_SIZE.x / texture_size.x,
		TARGET_SIZE.y / texture_size.y
	)

	var final_scale: float = cover_scale * BACKGROUND_ZOOM

	sprite.scale = Vector2(final_scale, final_scale)

	var final_size: Vector2 = texture_size * final_scale

	sprite.position = (
		(TARGET_SIZE - final_size) * 0.5
		+ BACKGROUND_OFFSET
	)

	add_child(sprite)