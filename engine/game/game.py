from engine.game.round import Round
from engine.game.score import ScoreEngine
from engine.game.match import Match
from engine.game.game_modes import GameMode, GameModeConfig


class Game:

    def __init__(
        self,
        players,
        mode=GameMode.QUICK,
        starting_round=3,
        dealer_name="Grace Lott",
    ):

        self.players = players
        self.mode = mode
        self.rounds_to_play = GameModeConfig.rounds_for(mode, starting_round)
        self.current_round_index = 0
        self.round_number = self.rounds_to_play[self.current_round_index]
        self.dealer_name = dealer_name
        self.round = None
        self.match = Match(players)

    def start_round(self):

        self.round = Round(
            self.players,
            self.round_number,
            dealer_name=self.dealer_name,
        )

        self.round.deal()

    def has_next_round(self):

        return self.current_round_index < len(self.rounds_to_play) - 1

    def next_round(self):

        if not self.has_next_round():
            return False

        self.current_round_index += 1
        self.round_number = self.rounds_to_play[self.current_round_index]
        self.start_round()

        return True

    def end_round(self):

        scores = {}

        for player in self.players:

            score = ScoreEngine.best_score(player.hand)

            player.total_score += score

            scores[player.name] = score

            self.match.add_round(
            self.current_round_index + 1,
            self.round_number,
            scores,
            events=self.round.events.events if self.round else [],
        )

        return scores

    def winner(self):

        return self.match.winner()

    def match_results(self):

        ordered_players = sorted(
            self.players,
            key=lambda player: player.total_score
        )

        return [
            {
                "name": player.name,
                "total_score": player.total_score,
            }
            for player in ordered_players
        ]
