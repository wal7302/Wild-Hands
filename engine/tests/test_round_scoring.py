from engine.models.player import Player
from engine.models.card import Card
from engine.models.card import Suit
from engine.game.game import Game


player1 = Player("Grace")
player2 = Player("Jack")

player1.hand = [
    Card(4, Suit.HEARTS),
    Card(5, Suit.HEARTS),
    Card(6, Suit.HEARTS),
]

player2.hand = [
    Card(10, Suit.CLUBS),
    Card(11, Suit.CLUBS),
]

game = Game([player1, player2])

scores = game.end_round()

assert scores["Grace"] == 0

assert scores["Jack"] == 20

assert player1.total_score == 0

assert player2.total_score == 20

print("Round scoring test passed.")
