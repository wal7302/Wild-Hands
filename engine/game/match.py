class Match:

    def __init__(self, players):

        self.players = players

        self.rounds = []

    def add_round(self, round_number, scores):

        self.rounds.append({

            "round": round_number,

            "scores": scores

        })

    def winner(self):

        return min(

            self.players,

            key=lambda p: p.total_score

        )
