class Turn:

    def __init__(self, player, deck):

        self.player = player
        self.deck = deck
        self.drawn_card = None
        self.discarded_card = None

    def draw(self):

        self.drawn_card = self.deck.draw()

        if self.drawn_card:
            self.player.draw(self.drawn_card)

        return self.drawn_card

    def discard(self, index):

        self.discarded_card = self.player.discard(index)

        return self.discarded_card
