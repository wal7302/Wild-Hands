class CardSorter:

    @staticmethod
    def by_rank(cards):
        return sorted(
            cards,
            key=lambda card: (
                card.rank,
                card.suit.value,
            )
        )

    @staticmethod
    def by_suit(cards):
        return sorted(
            cards,
            key=lambda card: (
                card.suit.value,
                card.rank,
            )
        )

    @staticmethod
    def manual(cards):
        return cards

    @staticmethod
    def sort(cards, preference):
        if preference == "rank":
            return CardSorter.by_rank(cards)

        if preference == "suit":
            return CardSorter.by_suit(cards)

        if preference == "manual":
            return CardSorter.manual(cards)

        if preference == "meld":
            return CardSorter.by_rank(cards)

        raise ValueError(f"Unknown sort preference: {preference}")
