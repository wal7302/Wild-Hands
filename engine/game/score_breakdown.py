from dataclasses import dataclass, field


@dataclass
class ScoreBreakdown:

    total_score: int
    penalty_cards: list = field(default_factory=list)
    meld_groups: list = field(default_factory=list)

    def penalty_card_displays(self):
        return [
            card.display
            for card in self.penalty_cards
        ]

    def meld_group_displays(self):
        return [
            [
                card.display
                for card in group
            ]
            for group in self.meld_groups
        ]
