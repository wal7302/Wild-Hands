from collections import Counter


class MeldEngine:

    @staticmethod
    def find_sets(cards):

        ranks = Counter(card.rank for card in cards if not card.is_wild)

        sets = []

        for rank, count in ranks.items():

            if count >= 3:

                sets.append(rank)

        return sets
