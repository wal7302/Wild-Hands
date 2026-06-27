from dataclasses import dataclass
from enum import Enum


class Suit(Enum):
    HEARTS = "♥"
    DIAMONDS = "♦"
    CLUBS = "♣"
    SPADES = "♠"


@dataclass(slots=True)
class Card:
    rank: int
    suit: Suit
    is_wild: bool = False

    @property
    def points(self) -> int:
        if self.is_wild:
            return 0
        if self.rank == 1:
            return 13
        if self.rank == 11:
            return 10
        if self.rank == 12:
            return 11
        if self.rank == 13:
            return 12
        return self.rank

    @property
    def display(self) -> str:
        names = {
            1: "A",
            11: "J",
            12: "Q",
            13: "K",
        }
        return f"{names.get(self.rank, self.rank)}{self.suit.value}"
