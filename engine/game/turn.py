class Turn:

    def __init__(self, player, round_state):

        self.player = player
        self.round_state = round_state

    def draw(self):

        if not self.round_state.turn_state.can_draw():
            return None

        card = self.round_state.draw_from_deck()

        if card:
            self.player.draw(card)
            self.round_state.turn_state.mark_drawn(card)

        return card

    def discard(self, index):

        if not self.round_state.turn_state.can_discard():
            return None

        card = self.player.discard(index)
        self.round_state.add_discard(card)
        self.round_state.turn_state.mark_discarded(card)

        return card
