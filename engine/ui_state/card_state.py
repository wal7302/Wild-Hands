class CardState:

    @staticmethod
    def from_card(card, index=None):
        return {
            "index": index,
            "rank": card.rank,
            "suit": card.suit.value,
            "display": card.display,
            "is_wild": card.is_wild,
            "points": card.points,
        }
