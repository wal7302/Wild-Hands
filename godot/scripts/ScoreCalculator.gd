class_name ScoreCalculator
extends RefCounted

const MINIMUM_LOSING_SCORE := 10


static func losing_round_score(cards: Array) -> int:
	return maxi(best_deadwood_score(cards), MINIMUM_LOSING_SCORE)


static func best_deadwood_score(cards: Array) -> int:
	if cards.is_empty():
		return 0

	var typed_cards: Array[Node2D] = []

	for card in cards:
		if card is Node2D:
			typed_cards.append(card)

	if typed_cards.is_empty():
		return 0

	var valid_meld_masks: Array[int] = (
		MeldAnalyzer.get_valid_meld_masks(typed_cards)
	)

	var full_mask: int = (1 << typed_cards.size()) - 1
	var memo: Dictionary = {}

	return minimum_deadwood_for_mask(
		full_mask,
		typed_cards,
		valid_meld_masks,
		memo
	)


static func minimum_deadwood_for_mask(
	remaining_mask: int,
	cards: Array[Node2D],
	valid_meld_masks: Array[int],
	memo: Dictionary
) -> int:
	if remaining_mask == 0:
		return 0

	if memo.has(remaining_mask):
		return int(memo[remaining_mask])

	var first_card_index: int = first_set_bit_index(remaining_mask)
	var first_card_bit: int = 1 << first_card_index

	var best_score: int = (
		card_score(cards[first_card_index])
		+ minimum_deadwood_for_mask(
			remaining_mask ^ first_card_bit,
			cards,
			valid_meld_masks,
			memo
		)
	)

	for meld_mask: int in valid_meld_masks:
		if (meld_mask & first_card_bit) == 0:
			continue

		if (meld_mask & remaining_mask) != meld_mask:
			continue

		best_score = mini(
			best_score,
			minimum_deadwood_for_mask(
				remaining_mask ^ meld_mask,
				cards,
				valid_meld_masks,
				memo
			)
		)

	memo[remaining_mask] = best_score
	return best_score


static func card_score(card: Node2D) -> int:
	var rank_name: String = String(card.rank)
	var points: int

	match rank_name:
		"A":
			points = 15
		"10", "J", "Q", "K":
			points = 10
		_:
			points = 5

	if bool(card.is_wild):
		points += 5

	return points


static func first_set_bit_index(mask: int) -> int:
	var index := 0
	var value := mask

	while (value & 1) == 0:
		value >>= 1
		index += 1

	return index
