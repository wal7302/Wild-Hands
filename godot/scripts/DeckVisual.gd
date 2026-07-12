class_name DeckVisual
extends Node2D

const CardScene := preload("res://scenes/Card.tscn")
const CARD_BACK_PATH := "res://assets/cards/card_back.png"

var card_size := Vector2(82, 118)

var card_visual: Node2D
var idle_tween: Tween
var draw_tween: Tween

func _ready():
	build_card_stack()
	call_deferred("start_idle_animation")

func build_card_stack():
	for layer: int in range(4, 0, -1):
		var offset := Vector2(
			float(layer) * 2.0,
			float(layer) * 2.2
		)

		if ResourceLoader.exists(CARD_BACK_PATH):
			var texture: Texture2D = load(CARD_BACK_PATH)
			var sprite := Sprite2D.new()

			sprite.texture = texture
			sprite.centered = false
			sprite.position = offset
			sprite.z_index = 5 - layer

			var texture_size: Vector2 = texture.get_size()

			if texture_size.x > 0.0 and texture_size.y > 0.0:
				sprite.scale = Vector2(
					card_size.x / texture_size.x,
					card_size.y / texture_size.y
				)

			add_child(sprite)
		else:
			var stack_card: Node2D = CardScene.instantiate()

			stack_card.position = offset
			stack_card.z_index = 5 - layer
			stack_card.set_card_back()

			if stack_card.has_method("set_interactable"):
				stack_card.set_interactable(false)

			add_child(stack_card)

	card_visual = CardScene.instantiate()
	card_visual.position = Vector2.ZERO
	card_visual.z_index = 6
	card_visual.set_card_back()

	if card_visual.has_method("set_interactable"):
		card_visual.set_interactable(false)

	add_child(card_visual)

func start_idle_animation():
	if card_visual == null:
		return

	if idle_tween != null and idle_tween.is_valid():
		idle_tween.kill()

	idle_tween = create_tween()
	idle_tween.set_loops()
	idle_tween.set_trans(Tween.TRANS_SINE)
	idle_tween.set_ease(Tween.EASE_IN_OUT)

	idle_tween.tween_interval(1.4)

	idle_tween.tween_property(
		card_visual,
		"position:y",
		-2.0,
		0.75
	)

	idle_tween.parallel().tween_property(
		card_visual,
		"rotation_degrees",
		-0.5,
		0.75
	)

	idle_tween.tween_property(
		card_visual,
		"position:y",
		0.0,
		0.75
	)

	idle_tween.parallel().tween_property(
		card_visual,
		"rotation_degrees",
		0.0,
		0.75
	)

func animate_draw():
	if card_visual == null:
		return

	if idle_tween != null and idle_tween.is_valid():
		idle_tween.kill()

	if draw_tween != null and draw_tween.is_valid():
		draw_tween.kill()

	card_visual.position = Vector2.ZERO
	card_visual.rotation_degrees = 0.0
	card_visual.scale = Vector2.ONE

	draw_tween = create_tween()
	draw_tween.set_trans(Tween.TRANS_BACK)
	draw_tween.set_ease(Tween.EASE_OUT)

	draw_tween.tween_property(
		card_visual,
		"position:y",
		-13.0,
		0.10
	)

	draw_tween.parallel().tween_property(
		card_visual,
		"rotation_degrees",
		-2.5,
		0.10
	)

	draw_tween.parallel().tween_property(
		card_visual,
		"scale",
		Vector2(1.035, 1.035),
		0.10
	)

	draw_tween.tween_property(
		card_visual,
		"position:y",
		0.0,
		0.14
	)

	draw_tween.parallel().tween_property(
		card_visual,
		"rotation_degrees",
		0.0,
		0.14
	)

	draw_tween.parallel().tween_property(
		card_visual,
		"scale",
		Vector2.ONE,
		0.14
	)

	draw_tween.tween_callback(start_idle_animation)