from engine.game.score import ScoreEngine
from engine.models.card import Card
from engine.models.card import Suit


cards = [

    Card(5, Suit.HEARTS),

    Card(11, Suit.CLUBS),

    Card(1, Suit.SPADES)

]

assert ScoreEngine.calculate(cards) == 28

print("Score test passed.")
