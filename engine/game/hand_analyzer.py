from itertools import combinations

from engine.game.meld import MeldEngine


class HandAnalyzer:

    @staticmethod
    def has_valid_group(cards):
        for size in range(3, len(cards) + 1):
            for group in combinations(cards, size):
                if MeldEngine.is_valid_set(list(group)):
                    return True

        return False

    @staticmethod
    def can_go_out(cards):
        if len(cards) < 3:
            return False

        return MeldEngine.is_valid_set(cards)
