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

meld_cards = [
    Card(4, Suit.HEARTS),
    Card(5, Suit.HEARTS),
    Card(6, Suit.HEARTS),
    Card(13, Suit.SPADES),
]

meld_sorted = CardSorter.by_meld_score(meld_cards)

assert len(meld_sorted) == 4

print("Card sorter test passed.")
