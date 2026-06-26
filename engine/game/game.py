from engine.game.round import Round
from engine.game.score import ScoreEngine
from engine.game.match import Match


class Game:

    def __init__(self, players):

        self.players = players
        self.round_number = 3
        self.round = None

    def start_round(self):

        self.round = Round(
            self.players,
            self.round_number
        )

        self.round.deal()

    def next_round(self):

        self.round_number += 1
        self.start_round()

    def end_round(self):

        scores = {}

        for player in self.players:

            score = ScoreEngine.best_score(player.hand)

            player.total_score += score

            scores[player.name] = score

        return scores
