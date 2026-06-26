from collections import Counter


class MeldEngine:

    @staticmethod
    def find_sets(cards):
        ranks = Counter(card.rank for card in cards if not card.is_wild)
        wilds = [card for card in cards if card.is_wild]

        sets = []

        for rank, count in ranks.items():
            if count + len(wilds) >= 3:
                sets.append(rank)

        return sets

    @staticmethod
    def has_simple_set(cards):
        return len(MeldEngine.find_sets(cards)) > 0

    @staticmethod
    def is_all_same_rank(cards):
        non_wild = [card for card in cards if not card.is_wild]

        if not non_wild:
            return True

        first_rank = non_wild[0].rank

        return all(card.rank == first_rank for card in non_wild)

    @staticmethod
    def is_valid_set(cards):
        if len(cards) < 3:
            return False

        return MeldEngine.is_all_same_rank(cards)
