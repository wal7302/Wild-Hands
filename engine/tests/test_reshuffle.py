from engine.models.player import Player
from engine.models.card import Card, Suit
from engine.game.round import Round


player = Player("Tasha")

round_state = Round([player], 3)

round_state.deck.cards.clear()

round_state.discard_pile = [
    Card(4, Suit.HEARTS),
    Card(5, Suit.CLUBS),
]

card = round_state.draw_from_deck()

assert card is not None
assert len(round_state.discard_pile) == 0
assert round_state.deck.remaining() == 1

print("Reshuffle test passed.")
