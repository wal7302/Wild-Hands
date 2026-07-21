class_name MeldAnalyzer
extends RefCounted

const MIN_MELD_SIZE := 3

const RANK_VALUES := {
	"A": 1,
	"2": 2,
	"3": 3,
	"4": 4,
	"5": 5,
	"6": 6,
	"7": 7,
	"8": 8,
	"9": 9,
	"10": 10,
	"J": 11,
	"Q": 12,
	"K": 13
}


static func can_go_out(cards: Array[Node2D]) -> bool:
	if cards.is_empty():
		return true

	if cards.size() < MIN_MELD_SIZE:
		return false

	var valid_meld_masks: Array[int] = (
		get_valid_meld_masks(cards)
	)

	if valid_meld_masks.is_empty():
		return false

	var full_mask: int = (
		1 << cards.size()
	) - 1

	var failed_masks: Dictionary = {}

	return can_partition_mask(
		full_mask,
		valid_meld_masks,
		failed_masks
	)


static func can_go_out_after_discard(
	cards: Array[Node2D],
	discard_card: Node2D
) -> bool:
	if discard_card == null:
		return false

	var remaining_cards: Array[Node2D] = []

	for card: Node2D in cards:
		if card != discard_card:
			remaining_cards.append(card)

	return can_go_out(remaining_cards)


static func get_meld_groups(
	cards: Array[Node2D]
) -> Array[Array]:
	var groups: Array[Array] = []

	if cards.is_empty():
		return groups

	var valid_meld_masks: Array[int] = (
		get_valid_meld_masks(cards)
	)

	var full_mask: int = (
		1 << cards.size()
	) - 1

	var chosen_masks: Array[int] = []
	var failed_masks: Dictionary = {}

	var found_solution: bool = (
		find_partition_masks(
			full_mask,
			valid_meld_masks,
			failed_masks,
			chosen_masks
		)
	)

	if not found_solution:
		return groups

	for meld_mask: int in chosen_masks:
		var group: Array[Node2D] = []

		for card_index: int in range(
			cards.size()
		):
			if (
				meld_mask
				& (1 << card_index)
			) != 0:
				group.append(cards[card_index])

		groups.append(group)

	return groups


static func get_valid_meld_masks(
	cards: Array[Node2D]
) -> Array[int]:
	var valid_masks: Array[int] = []
	var card_count: int = cards.size()
	var total_masks: int = 1 << card_count

	for mask: int in range(1, total_masks):
		var subset_size: int = count_mask_bits(mask)

		if subset_size < MIN_MELD_SIZE:
			continue

		var subset: Array[Node2D] = (
			cards_from_mask(cards, mask)
		)

		if (
			is_valid_book(subset)
			or is_valid_run(subset)
		):
			valid_masks.append(mask)

	valid_masks.sort_custom(
		func(mask_a: int, mask_b: int) -> bool:
			return (
				count_mask_bits(mask_a)
				> count_mask_bits(mask_b)
			)
	)

	return valid_masks


static func is_valid_meld(
	cards: Array[Node2D]
) -> bool:
	if cards.size() < MIN_MELD_SIZE:
		return false

	return (
		is_valid_book(cards)
		or is_valid_run(cards)
	)


static func is_valid_book(
	cards: Array[Node2D]
) -> bool:
	if cards.size() < MIN_MELD_SIZE:
		return false

	var target_rank := ""

	for card: Node2D in cards:
		if card.is_wild:
			continue

		var card_rank: String = String(card.rank)

		if target_rank.is_empty():
			target_rank = card_rank
		elif card_rank != target_rank:
			return false

	return true


static func is_valid_run(
	cards: Array[Node2D]
) -> bool:
	if cards.size() < MIN_MELD_SIZE:
		return false

	var wild_count := 0
	var target_suit := ""
	var natural_ranks: Array[int] = []

	for card: Node2D in cards:
		if card.is_wild:
			wild_count += 1
			continue

		var card_suit: String = String(card.suit)

		if target_suit.is_empty():
			target_suit = card_suit
		elif card_suit != target_suit:
			return false

		var rank_value: int = get_rank_value(
			String(card.rank)
		)

		if rank_value < 1:
			return false

		if rank_value in natural_ranks:
			return false

		natural_ranks.append(rank_value)

	if natural_ranks.is_empty():
		return true

	var run_length: int = cards.size()

	if can_fit_run(
		natural_ranks,
		wild_count,
		run_length,
		false
	):
		return true

	if 1 in natural_ranks:
		return can_fit_run(
			natural_ranks,
			wild_count,
			run_length,
			true
		)

	return false


static func can_fit_run(
	natural_ranks: Array[int],
	wild_count: int,
	run_length: int,
	ace_high: bool
) -> bool:
	var adjusted_ranks: Array[int] = []

	for rank_value: int in natural_ranks:
		if ace_high and rank_value == 1:
			adjusted_ranks.append(14)
		else:
			adjusted_ranks.append(rank_value)

	var maximum_rank := 13

	if ace_high:
		maximum_rank = 14

	var latest_start: int = (
		maximum_rank - run_length + 1
	)

	if latest_start < 1:
		return false

	for start_rank: int in range(
		1,
		latest_start + 1
	):
		var end_rank: int = (
			start_rank + run_length - 1
		)

		var all_naturals_fit := true

		for rank_value: int in adjusted_ranks:
			if (
				rank_value < start_rank
				or rank_value > end_rank
			):
				all_naturals_fit = false
				break

		if not all_naturals_fit:
			continue

		var missing_count := 0

		for expected_rank: int in range(
			start_rank,
			end_rank + 1
		):
			if expected_rank not in adjusted_ranks:
				missing_count += 1

		if missing_count == wild_count:
			return true

	return false


static func can_partition_mask(
	remaining_mask: int,
	valid_meld_masks: Array[int],
	failed_masks: Dictionary
) -> bool:
	if remaining_mask == 0:
		return true

	if failed_masks.has(remaining_mask):
		return false

	var first_card_bit: int = (
		remaining_mask & -remaining_mask
	)

	for meld_mask: int in valid_meld_masks:
		if (
			meld_mask
			& first_card_bit
		) == 0:
			continue

		if (
			meld_mask
			& remaining_mask
		) != meld_mask:
			continue

		var next_mask: int = (
			remaining_mask ^ meld_mask
		)

		if can_partition_mask(
			next_mask,
			valid_meld_masks,
			failed_masks
		):
			return true

	failed_masks[remaining_mask] = true
	return false


static func find_partition_masks(
	remaining_mask: int,
	valid_meld_masks: Array[int],
	failed_masks: Dictionary,
	chosen_masks: Array[int]
) -> bool:
	if remaining_mask == 0:
		return true

	if failed_masks.has(remaining_mask):
		return false

	var first_card_bit: int = (
		remaining_mask & -remaining_mask
	)

	for meld_mask: int in valid_meld_masks:
		if (
			meld_mask
			& first_card_bit
		) == 0:
			continue

		if (
			meld_mask
			& remaining_mask
		) != meld_mask:
			continue

		chosen_masks.append(meld_mask)

		var next_mask: int = (
			remaining_mask ^ meld_mask
		)

		if find_partition_masks(
			next_mask,
			valid_meld_masks,
			failed_masks,
			chosen_masks
		):
			return true

		chosen_masks.pop_back()

	failed_masks[remaining_mask] = true
	return false


static func cards_from_mask(
	cards: Array[Node2D],
	mask: int
) -> Array[Node2D]:
	var subset: Array[Node2D] = []

	for card_index: int in range(
		cards.size()
	):
		if (
			mask
			& (1 << card_index)
		) != 0:
			subset.append(cards[card_index])

	return subset


static func count_mask_bits(mask: int) -> int:
	var bit_count := 0
	var remaining := mask

	while remaining != 0:
		bit_count += remaining & 1
		remaining >>= 1

	return bit_count


static func get_rank_value(
	rank_name: String
) -> int:
	return int(
		RANK_VALUES.get(rank_name, -1)
	)