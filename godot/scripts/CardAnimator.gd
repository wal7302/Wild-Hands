class_name CardAnimator
extends RefCounted

static func move_card(
	card: Node2D,
	target_position: Vector2,
	target_rotation: float,
	duration: float = 0.28,
	delay: float = 0.0
) -> Tween:
	var tween: Tween = card.create_tween()

	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		card,
		"position",
		target_position,
		duration
	).set_delay(delay)

	tween.parallel().tween_property(
		card,
		"rotation_degrees",
		target_rotation,
		duration
	).set_delay(delay)

	tween.parallel().tween_property(
		card,
		"scale",
		Vector2.ONE,
		duration
	).set_delay(delay)

	return tween

static func deal_card(
	card: Node2D,
	target_position: Vector2,
	target_rotation: float,
	duration: float = 0.42,
	delay: float = 0.0,
	deal_variation: Vector2 = Vector2.ZERO
) -> Tween:
	var overshoot_position: Vector2 = target_position + deal_variation
	var overshoot_rotation: float = target_rotation + deal_variation.x * 0.12

	card.scale = Vector2(0.88, 0.88)

	var tween: Tween = card.create_tween()

	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		card,
		"position",
		overshoot_position,
		duration * 0.82
	).set_delay(delay)

	tween.parallel().tween_property(
		card,
		"rotation_degrees",
		overshoot_rotation,
		duration * 0.82
	).set_delay(delay)

	tween.parallel().tween_property(
		card,
		"scale",
		Vector2(1.045, 1.045),
		duration * 0.82
	).set_delay(delay)

	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		card,
		"position",
		target_position,
		duration * 0.18
	)

	tween.parallel().tween_property(
		card,
		"rotation_degrees",
		target_rotation,
		duration * 0.18
	)

	tween.parallel().tween_property(
		card,
		"scale",
		Vector2.ONE,
		duration * 0.18
	)

	return tween

static func select_card(
	card: Node2D,
	target_position: Vector2,
	target_rotation: float,
	duration: float = 0.16
) -> Tween:
	var tween: Tween = card.create_tween()

	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		card,
		"position",
		target_position,
		duration
	)

	tween.parallel().tween_property(
		card,
		"rotation_degrees",
		target_rotation,
		duration
	)

	tween.parallel().tween_property(
		card,
		"scale",
		Vector2(1.08, 1.08),
		duration
	)

	return tween

static func deselect_card(
	card: Node2D,
	target_position: Vector2,
	target_rotation: float,
	duration: float = 0.15
) -> Tween:
	var tween: Tween = card.create_tween()

	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		card,
		"position",
		target_position,
		duration
	)

	tween.parallel().tween_property(
		card,
		"rotation_degrees",
		target_rotation,
		duration
	)

	tween.parallel().tween_property(
		card,
		"scale",
		Vector2.ONE,
		duration
	)

	return tween

static func discard_card(
	card: Node2D,
	target_position: Vector2,
	target_rotation: float,
	duration: float = 0.42
) -> Tween:
	var start_position: Vector2 = card.position

	var midpoint: Vector2 = Vector2(
		lerp(start_position.x, target_position.x, 0.52),
		min(start_position.y, target_position.y) - 58.0
	)

	var tween: Tween = card.create_tween()

	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		card,
		"position",
		midpoint,
		duration * 0.46
	)

	tween.parallel().tween_property(
		card,
		"rotation_degrees",
		target_rotation * 0.55,
		duration * 0.46
	)

	tween.parallel().tween_property(
		card,
		"scale",
		Vector2(1.09, 1.09),
		duration * 0.30
	)

	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		card,
		"position",
		target_position,
		duration * 0.54
	)

	tween.parallel().tween_property(
		card,
		"rotation_degrees",
		target_rotation,
		duration * 0.54
	)

	tween.parallel().tween_property(
		card,
		"scale",
		Vector2.ONE,
		duration * 0.54
	)

	return tween

static func flip_card(
	card: Node2D,
	midpoint_callback: Callable,
	duration: float = 0.26
) -> Tween:
	var tween: Tween = card.create_tween()

	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(
		card,
		"scale:x",
		0.0,
		duration * 0.5
	)

	tween.tween_callback(midpoint_callback)

	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		card,
		"scale:x",
		1.0,
		duration * 0.5
	)

	return tween

static func pulse_card(
	card: Node2D,
	duration: float = 0.18
) -> Tween:
	var tween: Tween = card.create_tween()

	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		card,
		"scale",
		Vector2(1.075, 1.075),
		duration * 0.5
	)

	tween.tween_property(
		card,
		"scale",
		Vector2.ONE,
		duration * 0.5
	)

	return tween