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

        scored_options.sort(
            key=lambda option: option["score"]
        )

        best_index = scored_options[0]["index"]

        personality = getattr(player, "personality", None)

        if personality is None:
            return best_index

        risk = personality.discard_risk

        if risk <= 0:
            return best_index

        if random.random() > risk:
            return best_index

        risk_pool_size = min(
            len(scored_options),
            max(2, int(len(scored_options) * risk) + 1)
        )

        risky_choice = random.choice(
            scored_options[:risk_pool_size]
        )

        return risky_choice["index"]
