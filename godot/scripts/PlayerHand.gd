class_name PlayerHand
extends Node2D

var cards := []

func add_card(card: Node2D):
	cards.append(card)
	add_child(card)
	arrange_cards()

func arrange_cards():
	var count := cards.size()
	if count == 0:
		return

	var spacing := 54
	var start_x := -((count - 1) * spacing) / 2.0

	for i in range(count):
		var card = cards[i]
		var target_position := Vector2(start_x + i * spacing, 0)
		var target_rotation := (i - (count - 1) / 2.0) * 6

		var tween := create_tween()
		tween.tween_property(card, "position", target_position, 0.25)
		tween.parallel().tween_property(card, "rotation_degrees", target_rotation, 0.25)
