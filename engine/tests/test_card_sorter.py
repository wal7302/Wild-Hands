from engine.models.card import Card, Suit
from engine.game.card_sorter import CardSorter


cards = [
    Card(13, Suit.SPADES),
    Card(2, Suit.HEARTS),
    Card(7, Suit.CLUBS),
]

rank_sorted = CardSorter.by_rank(cards)

assert rank_sorted[0].rank == 2
assert rank_sorted[1].rank == 7
assert rank_sorted[2].rank == 13

suit_sorted = CardSorter.by_suit(cards)

assert len(suit_sorted) == 3

print("Card sorter test passed.")
