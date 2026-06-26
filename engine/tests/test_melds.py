from engine.models.card import Card, Suit
from engine.game.meld import MeldEngine
from engine.game.hand_analyzer import HandAnalyzer


run = [
    Card(4, Suit.HEARTS),
    Card(5, Suit.HEARTS),
    Card(6, Suit.HEARTS),
]

assert MeldEngine.is_valid_run(run) is True

set_cards = [
    Card(9, Suit.HEARTS),
    Card(9, Suit.CLUBS),
    Card(9, Suit.SPADES),
]

assert MeldEngine.is_valid_set(set_cards) is True

wild_run = [
    Card(7, Suit.DIAMONDS),
    Card(9, Suit.DIAMONDS),
    Card(3, Suit.CLUBS, is_wild=True),
]

assert MeldEngine.is_valid_run(wild_run) is True

full_hand = [
    Card(4, Suit.HEARTS),
    Card(5, Suit.HEARTS),
    Card(6, Suit.HEARTS),
    Card(9, Suit.HEARTS),
    Card(9, Suit.CLUBS),
    Card(9, Suit.SPADES),
]

assert HandAnalyzer.can_go_out(full_hand) is True

print("Meld tests passed.")
