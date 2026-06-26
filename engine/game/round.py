from engine.models.deck import Deck


class Round:

    def __init__(self, players, cards_dealt):

        self.players = players

        self.cards_dealt = cards_dealt

        self.wild_rank = cards_dealt

        self.deck = Deck()

        self.deck.set_wild_rank(cards_dealt)

    def deal(self):

        for _ in range(self.cards_dealt):

            for player in self.players:

                card = self.deck.draw()

                card.is_wild = card.rank == self.wild_rank

                player.draw(card)
