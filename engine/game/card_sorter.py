from engine.game.score import ScoreEngine


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
    def by_meld_score(cards):
        scored_cards = []

        for index, card in enumerate(cards):
            test_hand = cards.copy()
            test_hand.pop(index)

            score_without_card = ScoreEngine.best_score(test_hand)

            scored_cards.append(
                {
                    "card": card,
                    "index": index,
                    "score_without_card": score_without_card,
                }
            )

        scored_cards.sort(
            key=lambda item: (
                item["score_without_card"],
                item["card"].rank,
                item["card"].suit.value,
            )
        )

        return [
            item["card"]
            for item in scored_cards
        ]

    @staticmethod
    def sort(cards, preference):
        if preference == "rank":
            return CardSorter.by_rank(cards)

        if preference == "suit":
            return CardSorter.by_suit(cards)

        if preference == "manual":
            return CardSorter.manual(cards)

        if preference == "meld":
            return CardSorter.by_meld_score(cards)

        raise ValueError(f"Unknown sort preference: {preference}")
