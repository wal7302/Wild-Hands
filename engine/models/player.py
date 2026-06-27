from dataclasses import dataclass, field

from .card import Card
from engine.game.card_sorter import CardSorter


@dataclass
class Player:

    name: str

    hand: list[Card] = field(default_factory=list)

    total_score: int = 0

    coins: int = 1000

    xp: int = 0

    def draw(self, card: Card):

        self.hand.append(card)

    def discard(self, index: int):

        return self.hand.pop(index)

    def sort_hand(self, preference="manual"):

        self.hand = CardSorter.sort(
            self.hand,
            preference
        )

    def sort_rank(self):

        self.sort_hand("rank")

    def sort_suit(self):

        self.sort_hand("suit")
