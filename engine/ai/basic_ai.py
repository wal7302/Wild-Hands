from engine.game.score import ScoreEngine


class BasicAI:

    def choose_discard_index(self, player):
        best_index = 0
        best_score = None

        for index in range(len(player.hand)):
            test_hand = player.hand.copy()
            test_hand.pop(index)

            score = ScoreEngine.best_score(test_hand)

            if best_score is None or score < best_score:
                best_score = score
                best_index = index

        return best_index
