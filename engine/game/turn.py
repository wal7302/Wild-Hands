class Turn:

    def __init__(self, player, round_state):

        self.player = player
        self.round_state = round_state
        self.drawn_card = None
        self.discarded_card = None

    def draw(self):

        self.drawn_card = self.round_state.deck.draw()

        if self.drawn_card:
            self.drawn_card.is_wild = self.drawn_card.rank == self.round_state.wild_rank
            self.player.draw(self.drawn_card)

        return self.drawn_card

    def discard(self, index):

        self.discarded_card = self.player.discard(index)
        self.round_state.add_discard(self.discarded_card)

        return self.discarded_card
