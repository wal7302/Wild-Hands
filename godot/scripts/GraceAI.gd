class_name GraceAI
extends RefCounted


class CardProxy:
	extends Node2D

	var rank := ""
	var suit := ""
	var card_id := ""
	var is_wild := false

	func _init(data: Dictionary):
		rank = String(data.get("rank", ""))
		suit = String(data.get("suit", ""))
		card_id = String(data.get("card_id", ""))
		is_wild = bool(data.get("wild", false))


func should_take_discard(
	hand_data: Array[Dictionary],
	discard_data: Dictionary
) -> bool:
	if discard_data.is_empty():
		return false

	var current_score: int = score_hand(hand_data)

	var test_hand: Array[Dictionary] = (
		hand_data.duplicate(true)
	)

	test_hand.append(discard_data.duplicate(true))

	var protected_index: int = test_hand.size() - 1

	var result: Dictionary = find_best_discard(
		test_hand,
		protected_index
	)

	if bool(result.get("can_go_out", false)):
		return true

	var improved_score: int = int(
		result.get("score", current_score)
	)

	return improved_score < current_score


func choose_discard_index(
	hand_data: Array[Dictionary],
	protected_index: int = -1
) -> int:
	var result: Dictionary = find_best_discard(
		hand_data,
		protected_index
	)

	return int(result.get("index", -1))


func can_go_out(
	hand_data: Array[Dictionary]
) -> bool:
	var proxy_cards: Array[Node2D] = (
		create_proxy_cards(hand_data)
	)

	var result: bool = MeldAnalyzer.can_go_out(
		proxy_cards
	)

	free_proxy_cards(proxy_cards)
	return result


func score_hand(
	hand_data: Array[Dictionary]
) -> int:
	var proxy_cards: Array[Node2D] = (
		create_proxy_cards(hand_data)
	)

	var score: int = ScoreCalculator.best_deadwood_score(
		proxy_cards
	)

	free_proxy_cards(proxy_cards)
	return score


func find_best_discard(
	hand_data: Array[Dictionary],
	protected_index: int = -1
) -> Dictionary:
	var best_index := -1
	var best_score := 999999
	var best_go_out := false
	var best_is_wild := true

	for discard_index: int in range(
		hand_data.size()
	):
		if discard_index == protected_index:
			continue

		var remaining_hand: Array[Dictionary] = []

		for card_index: int in range(
			hand_data.size()
		):
			if card_index != discard_index:
				remaining_hand.append(
					hand_data[card_index].duplicate(true)
				)

		var goes_out: bool = can_go_out(
			remaining_hand
		)

		var deadwood_score: int = score_hand(
			remaining_hand
		)

		var discarded_is_wild: bool = bool(
			hand_data[discard_index].get(
				"wild",
				false
			)
		)

		if goes_out and not best_go_out:
			best_index = discard_index
			best_score = deadwood_score
			best_go_out = true
			best_is_wild = discarded_is_wild
			continue

		if goes_out != best_go_out:
			continue

		if deadwood_score < best_score:
			best_index = discard_index
			best_score = deadwood_score
			best_is_wild = discarded_is_wild
			continue

		if (
			deadwood_score == best_score
			and best_is_wild
			and not discarded_is_wild
		):
			best_index = discard_index
			best_is_wild = false

	return {
		"index": best_index,
		"score": best_score,
		"can_go_out": best_go_out
	}


func create_proxy_cards(
	hand_data: Array[Dictionary]
) -> Array[Node2D]:
	var proxy_cards: Array[Node2D] = []

	for data: Dictionary in hand_data:
		proxy_cards.append(
			CardProxy.new(data)
		)

	return proxy_cards


func free_proxy_cards(
	proxy_cards: Array[Node2D]
):
	for card: Node2D in proxy_cards:
		if is_instance_valid(card):
			card.free()

	proxy_cards.clear()