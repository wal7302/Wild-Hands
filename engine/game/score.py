from engine.models.card import Card


class ScoreEngine:

    @staticmethod
    def calculate(cards: list[Card]) -> int:

        score = 0

        for card in cards:

            score += card.points

        return score
