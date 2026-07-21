class_name PlayerHand
extends Node2D

var cards := []
var selected_card: Node2D = null


func add_card(card: Node2D):
	cards.append(card)
	add_child(card)

	if card.has_signal("selected"):
		card.selected.connect(_on_card_selected)

	if card.has_signal("deselected"):
		card.deselected.connect(_on_card_deselected)

	arrange_cards()


func remove_card(card: Node2D):
	if card in cards:
		cards.erase(card)

	if selected_card == card:
		selected_card = null

	if card.has_method("force_deselect"):
		card.force_deselect()

	arrange_cards()


func arrange_cards():
	var count := cards.size()

	if count == 0:
		return

	# Slightly tighter spacing for larger hands
	var spacing := clamp(78.0 - max(0, count - 5) * 3.5, 50.0, 78.0)

	var total_width := (count - 1) * spacing
	var start_x := -total_width * 0.5

	# Gentle fan
	var max_rotation := min(16.0, count * 1.8)

	# Subtle arc
	var arc_height := min(26.0, count * 2.2)

	for i in range(count):
		var card = cards[i]

		var percent := 0.0
		if count > 1:
			percent = float(i) / float(count - 1)

		var centered := percent - 0.5

		var x := start_x + spacing * i

		# Creates the curved hand
		var y := pow(centered * 2.0, 2.0) * arc_height

		# Middle cards slightly lower than edges
		y = arc_height - y

		var rotation := lerp(
			-max_rotation,
			max_rotation,
			percent
		)

		if card == selected_card:
			y -= 36
			card.z_index = 100
		else:
			card.z_index = i

		var tween := create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)

		tween.tween_property(
			card,
			"position",
			Vector2(x, y),
			0.20
		)

		tween.parallel().tween_property(
			card,
			"rotation_degrees",
			rotation,
			0.20
		)


func _on_card_selected(card):
	if selected_card != null and selected_card != card:
		if selected_card.has_method("force_deselect"):
			selected_card.force_deselect()

	selected_card = card
	arrange_cards()


func _on_card_deselected(card):
	if selected_card == card:
		selected_card = null

	arrange_cards()