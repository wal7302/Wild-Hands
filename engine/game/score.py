from itertools import combinations

from engine.models.card import Card
from engine.game.meld import MeldEngine
from engine.game.score_breakdown import ScoreBreakdown


class ScoreEngine:

    @staticmethod
    def calculate(cards: list[Card]) -> int:
        return sum(card.points for card in cards)

    @staticmethod
    def best_score(cards: list[Card]) -> int:
        return ScoreEngine.best_breakdown(cards).total_score

    @staticmethod
    def best_breakdown(cards: list[Card]) -> ScoreBreakdown:
        if not cards:
            return ScoreBreakdown(
                total_score=0,
                penalty_cards=[],
                meld_groups=[],
            )

        best = ScoreBreakdown(
            total_score=ScoreEngine.calculate(cards),
            penalty_cards=cards.copy(),
            meld_groups=[],
        )

        for size in range(3, len(cards) + 1):
            for group in combinations(cards, size):
                group = list(group)

                if MeldEngine.is_valid_meld(group):
                    leftovers = cards.copy()

                    for card in group:
                        leftovers.remove(card)

                    child = ScoreEngine.best_breakdown(leftovers)

                    score = child.total_score

                    if score < best.total_score:
                        best = ScoreBreakdown(
                            total_score=score,
                            penalty_cards=child.penalty_cards,
                            meld_groups=[group] + child.meld_groups,
                        )

        return best
