from engine.game.round import Round


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
