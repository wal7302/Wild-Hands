class TurnPhase:

    WAITING_TO_DRAW = "waiting_to_draw"
    WAITING_TO_DISCARD = "waiting_to_discard"
    TURN_COMPLETE = "turn_complete"


class TurnState:

    def __init__(self):

        self.phase = TurnPhase.WAITING_TO_DRAW
        self.drawn_card = None
        self.discarded_card = None

    def can_draw(self):

        return self.phase == TurnPhase.WAITING_TO_DRAW

    def can_discard(self):

        return self.phase == TurnPhase.WAITING_TO_DISCARD

    def mark_drawn(self, card):

        self.drawn_card = card
        self.phase = TurnPhase.WAITING_TO_DISCARD

    def mark_discarded(self, card):

        self.discarded_card = card
        self.phase = TurnPhase.TURN_COMPLETE

    def is_complete(self):

        return self.phase == TurnPhase.TURN_COMPLETE
