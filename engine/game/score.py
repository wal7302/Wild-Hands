from itertools import combinations

from engine.models.card import Card
from engine.game.meld import MeldEngine


class ScoreEngine:

    @staticmethod
    def calculate(cards: list[Card]) -> int:
        return sum(card.points for card in cards)

    @staticmethod
    def best_score(cards: list[Card]) -> int:
        if not cards:
            return 0

        best = ScoreEngine.calculate(cards)

        for size in range(3, len(cards) + 1):
            for group in combinations(cards, size):
                group = list(group)

                if MeldEngine.is_valid_meld(group):
                    leftovers = cards.copy()

                    for card in group:
                        leftovers.remove(card)

                    score = ScoreEngine.best_score(leftovers)

                    if score < best:
                        best = score

        return best
