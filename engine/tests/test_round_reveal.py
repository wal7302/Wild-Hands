from engine.models.player import Player
from engine.models.card import Card, Suit
from engine.game.round_reveal import RoundReveal


player = Player("Tasha")

player.hand = [
    Card(4, Suit.HEARTS),
    Card(5, Suit.HEARTS),
    Card(6, Suit.HEARTS),
    Card(13, Suit.CLUBS),
]

reveals = RoundReveal.reveal([player])

assert len(reveals) == 1
assert reveals[0].player_name == "Tasha"
assert reveals[0].total_score == 12
assert reveals[0].summary()["penalty_cards"] == ["K♣"]

print("Round reveal test passed.")
