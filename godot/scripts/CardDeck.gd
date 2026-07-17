class_name CardDeck
extends RefCounted

var cards: Array[CardData] = []
var rng := RandomNumberGenerator.new()

func _init():
	rng.randomize()

func build(number_of_decks: int = 1):
	cards.clear()

	var suits: Array[Dictionary] = [
		{"symbol": "♥", "code": "H"},
		{"symbol": "♦", "code": "D"},
		{"symbol": "♣", "code": "C"},
		{"symbol": "♠", "code": "S"}
	]

	for _deck_number: int in range(number_of_decks):
		for suit_data: Dictionary in suits:
			for rank_value: int in range(1, 14):
				var rank_label: String = GameConfig.rank_label(
					rank_value
				)

				var card_id: String = (
					rank_label
					+ String(suit_data["code"])
				)

				var card := CardData.new(
					card_id,
					rank_label,
					rank_value,
					String(suit_data["symbol"]),
					String(suit_data["code"])
				)

				cards.append(card)

func shuffle():
	for i: int in range(cards.size() - 1, 0, -1):
		var swap_index: int = rng.randi_range(0, i)

		var temporary_card: CardData = cards[i]
		cards[i] = cards[swap_index]
		cards[swap_index] = temporary_card

func draw_card(wild_rank: int) -> Dictionary:
	if cards.is_empty():
		return {}

	var card: CardData = cards.pop_back()
	card.set_wild_rank(wild_rank)

	return card.to_dictionary()

func remaining_cards() -> int:
	return cards.size()