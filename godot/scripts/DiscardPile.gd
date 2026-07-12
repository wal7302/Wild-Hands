class_name DiscardPileVisual
extends Node2D

const DISCARD_SLOT_PATH := "res://assets/ui/discard_slot.png"

var pile_size := Vector2(82, 118)

var pile_color := Color("#E9CFA8")
var border_color := Color("#7A1E2C")
var gold := Color("#D8A441")

func _ready():
	if ResourceLoader.exists(DISCARD_SLOT_PATH):
		add_texture()
	else:
		queue_redraw()

func add_texture():
	var texture: Texture2D = load(DISCARD_SLOT_PATH)
	var sprite := Sprite2D.new()

	sprite.texture = texture
	sprite.centered = false
	sprite.position = Vector2.ZERO

	var texture_size: Vector2 = texture.get_size()

	if texture_size.x > 0.0 and texture_size.y > 0.0:
		sprite.scale = Vector2(
			pile_size.x / texture_size.x,
			pile_size.y / texture_size.y
		)

	add_child(sprite)

func _draw():
	var shadow_style := StyleBoxFlat.new()
	shadow_style.bg_color = Color(0, 0, 0, 0.28)
	shadow_style.set_corner_radius_all(10)

	draw_style_box(
		shadow_style,
		Rect2(Vector2(6, 8), pile_size)
	)

	var slot_style := StyleBoxFlat.new()
	slot_style.bg_color = pile_color
	slot_style.border_color = border_color
	slot_style.set_border_width_all(3)
	slot_style.set_corner_radius_all(10)

	draw_style_box(
		slot_style,
		Rect2(Vector2.ZERO, pile_size)
	)

	var inner_style := StyleBoxFlat.new()
	inner_style.bg_color = Color(1, 1, 1, 0.08)
	inner_style.border_color = gold
	inner_style.set_border_width_all(1)
	inner_style.set_corner_radius_all(7)

	draw_style_box(
		inner_style,
		Rect2(8, 8, 66, 102)
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(15, 67),
		"DROP",
		HORIZONTAL_ALIGNMENT_CENTER,
		52,
		12,
		Color(0.35, 0.12, 0.09, 0.55)
	)