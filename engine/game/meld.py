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

    @staticmethod
    def rank_options(card):
        if card.rank == 1:
            return [1, 14]

        return [card.rank]

    @staticmethod
    def is_valid_run(cards):
        if len(cards) < 3:
            return False

        wild_count = sum(1 for card in cards if card.is_wild)
        non_wild = [card for card in cards if not card.is_wild]

        if not non_wild:
            return True

        suits = set(card.suit for card in non_wild)

        if len(suits) != 1:
            return False

        rank_sets = [MeldEngine.rank_options(card) for card in non_wild]

        def backtrack(index, selected):
            if index == len(rank_sets):
                selected = sorted(selected)

                if len(set(selected)) != len(selected):
                    return False

                gaps = 0

                for i in range(len(selected) - 1):
                    gaps += selected[i + 1] - selected[i] - 1

                return gaps <= wild_count

            for rank in rank_sets[index]:
                if backtrack(index + 1, selected + [rank]):
                    return True

            return False

        return backtrack(0, [])

    @staticmethod
    def is_valid_meld(cards):
        return MeldEngine.is_valid_set(cards) or MeldEngine.is_valid_run(cards)
