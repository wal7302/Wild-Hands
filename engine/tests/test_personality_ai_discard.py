from engine.ai.ai_player import AIPlayer
from engine.models.card import Card, Suit


ai = AIPlayer("Rico", personality="competitive_one")

ai.hand = [
    Card(4, Suit.HEARTS),
    Card(5, Suit.HEARTS),
    Card(6, Suit.HEARTS),
    Card(13, Suit.CLUBS),
]

discard_index = ai.choose_discard_index()

assert discard_index == 3

print("Personality AI discard test passed.")
