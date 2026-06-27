class_name TableAnimationDirector
extends Node

func animate_card_from_deck(card: Node2D, deck_position: Vector2, target_position: Vector2, duration: float = 0.35, delay: float = 0.0):
	card.global_position = deck_position

	var tween := create_tween()
	tween.tween_interval(delay)
	tween.tween_property(card, "global_position", target_position, duration)
	return tween

func animate_card_to_discard(card: Node2D, discard_position: Vector2, duration: float = 0.35):
	var tween := create_tween()
	tween.tween_property(card, "global_position", discard_position, duration)
	return tween

func animate_hand_reach(hand: Node2D, from_position: Vector2, to_position: Vector2, duration: float = 0.3):
	hand.show_hand(from_position)

	var tween := create_tween()
	tween.tween_property(hand, "global_position", to_position, duration)
	return tween

func animate_hand_return(hand: Node2D, to_position: Vector2, duration: float = 0.3):
	var tween := create_tween()
	tween.tween_property(hand, "global_position", to_position, duration)
	return tween
