class_name DiscardPile
extends Node2D

var top_card: Node2D = null

func place_card(card: Node2D):
	if top_card != null:
		top_card.z_index = 0

	top_card = card
	add_child(card)
	card.position = Vector2.ZERO
	card.rotation_degrees = randf_range(-6, 6)
	card.z_index = 10
