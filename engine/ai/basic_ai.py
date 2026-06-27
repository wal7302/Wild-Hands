import random

from engine.game.score import ScoreEngine


class BasicAI:

    def choose_discard_index(self, player):
        scored_options = []

        for index in range(len(player.hand)):
            test_hand = player.hand.copy()
            discarded_card = test_hand.pop(index)

            score = ScoreEngine.best_score(test_hand)

            scored_options.append(
                {
                    "index": index,
                    "score": score,
                    "discarded_card": discarded_card,
                }
            )

        if not scored_options:
            return 0

        scored_options.sort(key=lambda option: option["score"])

        personality = getattr(player, "personality", None)

        if personality is None:
            return scored_options[0]["index"]

        risk = personality.discard_risk

        # Low-risk players usually choose best discard.
        if random.random() > risk:
            return scored_options[0]["index"]

        # Higher-risk personalities may choose from weaker options.
        pool_size = min(
            len(scored_options),
            max(2, int(len(scored_options) * (risk + 0.25)))
        )

        risky_pool = scored_options[:pool_size]

        # Crazy/drunk personalities sometimes make truly bad choices.
        if risk >= 0.55 and random.random() < risk:
            risky_pool = scored_options

        choice = random.choice(risky_pool)

        return choice["index"]
