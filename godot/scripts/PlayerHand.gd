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

	var spacing := 58
	var start_x := -((count - 1) * spacing) / 2.0

	for i in range(count):
		var card = cards[i]
		var target_position := Vector2(start_x + i * spacing, 0)
		var target_rotation := (i - (count - 1) / 2.0) * 6

		var y_offset := -22 if card == selected_card else 0

		var tween := create_tween()
		tween.tween_property(card, "position", target_position + Vector2(0, y_offset), 0.18)
		tween.parallel().tween_property(card, "rotation_degrees", target_rotation, 0.18)

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
