class Turn:

    def __init__(self, player, deck):

        self.player = player

        self.deck = deck

    def draw(self):

        card = self.deck.draw()

        if card:

            self.player.draw(card)

        return card

    def discard(self, index):

        return self.player.discard(index)
