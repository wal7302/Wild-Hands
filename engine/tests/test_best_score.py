from engine.models.card import Card, Suit
from engine.game.score import ScoreEngine


hand = [
    Card(4, Suit.HEARTS),
    Card(5, Suit.HEARTS),
    Card(6, Suit.HEARTS),
    Card(9, Suit.CLUBS),
]

assert ScoreEngine.best_score(hand) == 9

hand_with_set = [
    Card(9, Suit.HEARTS),
    Card(9, Suit.CLUBS),
    Card(9, Suit.SPADES),
    Card(13, Suit.DIAMONDS),
]

assert ScoreEngine.best_score(hand_with_set) == 12

perfect_hand = [
    Card(4, Suit.HEARTS),
    Card(5, Suit.HEARTS),
    Card(6, Suit.HEARTS),
    Card(9, Suit.HEARTS),
    Card(9, Suit.CLUBS),
    Card(9, Suit.SPADES),
]

assert ScoreEngine.best_score(perfect_hand) == 0

print("Best score tests passed.")
