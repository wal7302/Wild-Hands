import random

from .card import Card
from .card import Suit


class Deck:

    def __init__(self):
        self.cards = [
            Card(rank, suit)
            for suit in Suit
            for rank in range(1, 14)
        ]

        self.shuffle()

    def shuffle(self):
        random.shuffle(self.cards)

    def draw(self):
        if not self.cards:
            return None

        return self.cards.pop()

    def remaining(self):
        return len(self.cards)

    def reset_wilds(self):
        for card in self.cards:
            card.is_wild = False

    def set_wild_rank(self, rank):
        for card in self.cards:
            card.is_wild = card.rank == rank
