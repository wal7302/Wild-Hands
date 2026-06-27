from dataclasses import dataclass, field

from engine.game.score import ScoreEngine


@dataclass
class PlayerReveal:

    player_name: str
    total_score: int
    penalty_cards: list = field(default_factory=list)
    meld_groups: list = field(default_factory=list)

    def summary(self):
        return {
            "player": self.player_name,
            "score": self.total_score,
            "penalty_cards": [
                card.display
                for card in self.penalty_cards
            ],
            "melds": [
                [
                    card.display
                    for card in group
                ]
                for group in self.meld_groups
            ],
        }


class RoundReveal:

    @staticmethod
    def reveal(players):
        reveals = []

        for player in players:
            breakdown = ScoreEngine.best_breakdown(player.hand)

            reveals.append(
                PlayerReveal(
                    player_name=player.name,
                    total_score=breakdown.total_score,
                    penalty_cards=breakdown.penalty_cards,
                    meld_groups=breakdown.meld_groups,
                )
            )

        return reveals
