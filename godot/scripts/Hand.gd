class_name Hand
extends RefCounted

const SUIT_SORT_ORDER := {
	"♥": 0,
	"♦": 1,
	"♣": 2,
	"♠": 3
}

const RANK_SORT_ORDER := {
	"A": 0,
	"2": 1,
	"3": 2,
	"4": 3,
	"5": 4,
	"6": 5,
	"7": 6,
	"8": 7,
	"9": 8,
	"10": 9,
	"J": 10,
	"Q": 11,
	"K": 12
}

var cards: Array[Node2D] = []
var manual_order_enabled := false


func add_card(card: Node2D):
	if card == null:
		return

	cards.append(card)


func remove_card(card: Node2D) -> bool:
	var card_index: int = cards.find(card)

	if card_index < 0:
		return false

	cards.remove_at(card_index)
	return true


func contains(card: Node2D) -> bool:
	return card in cards


func size() -> int:
	return cards.size()


func is_empty() -> bool:
	return cards.is_empty()


func clear():
	cards.clear()
	manual_order_enabled = false


func clear_and_free():
	for card: Node2D in cards:
		if is_instance_valid(card):
			card.queue_free()

	clear()


func enable_manual_order():
	manual_order_enabled = true


func disable_manual_order():
	manual_order_enabled = false


func sort_default():
	manual_order_enabled = false
	cards.sort_custom(compare_cards)


func sort_if_automatic():
	if manual_order_enabled:
		return

	cards.sort_custom(compare_cards)


func move_card(
	card: Node2D,
	new_index: int
) -> bool:
	var current_index: int = cards.find(card)

	if current_index < 0:
		return false

	var safe_index: int = clampi(
		new_index,
		0,
		cards.size() - 1
	)

	if safe_index == current_index:
		return true

	cards.remove_at(current_index)

	if safe_index >= cards.size():
		cards.append(card)
	else:
		cards.insert(safe_index, card)

	manual_order_enabled = true
	return true


func can_go_out() -> bool:
	return MeldAnalyzer.can_go_out(cards)


func can_go_out_after_discard(
	discard_card: Node2D
) -> bool:
	if discard_card == null:
		return false

	if discard_card not in cards:
		return false

	return MeldAnalyzer.can_go_out_after_discard(
		cards,
		discard_card
	)


func get_meld_groups() -> Array[Array]:
	return MeldAnalyzer.get_meld_groups(cards)


func get_cards_after_removing(
	removed_card: Node2D
) -> Array[Node2D]:
	var remaining_cards: Array[Node2D] = []

	for card: Node2D in cards:
		if card != removed_card:
			remaining_cards.append(card)

	return remaining_cards


func compare_cards(
	card_a: Node2D,
	card_b: Node2D
) -> bool:
	var suit_a: int = get_suit_sort_value(
		String(card_a.suit)
	)

	var suit_b: int = get_suit_sort_value(
		String(card_b.suit)
	)

	if suit_a != suit_b:
		return suit_a < suit_b

	var rank_a: int = get_rank_sort_value(
		String(card_a.rank)
	)

	var rank_b: int = get_rank_sort_value(
		String(card_b.rank)
	)

	if rank_a != rank_b:
		return rank_a < rank_b

	return String(card_a.card_id) < String(
		card_b.card_id
	)


func get_suit_sort_value(
	suit_value: String
) -> int:
	return int(
		SUIT_SORT_ORDER.get(
			suit_value,
			99
		)
	)


func get_rank_sort_value(
	rank_value: String
) -> int:
	return int(
		RANK_SORT_ORDER.get(
			rank_value,
			99
		)
	)