from itertools import combinations

from engine.game.meld import MeldEngine


class HandAnalyzer:

    @staticmethod
    def can_go_out(cards):
        if len(cards) < 3:
            return False

        return HandAnalyzer._can_partition_into_melds(tuple(cards))

    @staticmethod
    def _can_partition_into_melds(cards):
        cards = list(cards)

        if len(cards) == 0:
            return True

        if len(cards) < 3:
            return False

        first_card = cards[0]
        remaining_cards = cards[1:]

        for size in range(2, len(remaining_cards) + 1):
            for combo in combinations(remaining_cards, size):
                group = [first_card] + list(combo)

                if MeldEngine.is_valid_meld(group):
                    leftovers = cards.copy()

                    for card in group:
                        leftovers.remove(card)

                    if HandAnalyzer._can_partition_into_melds(tuple(leftovers)):
                        return True

        return False
