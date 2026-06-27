from engine.models.card import Card, Suit
from engine.game.score import ScoreEngine


hand = [
    Card(4, Suit.HEARTS),
    Card(5, Suit.HEARTS),
    Card(6, Suit.HEARTS),
    Card(13, Suit.CLUBS),
]

breakdown = ScoreEngine.best_breakdown(hand)

assert breakdown.total_score == 12
assert len(breakdown.meld_groups) == 1
assert len(breakdown.penalty_cards) == 1
assert breakdown.penalty_cards[0].rank == 13

print("Score breakdown test passed.")
