class Match:

    def __init__(self, players):

        self.players = players
        self.rounds = []

    def add_round(self, round_number, hand_size, scores, events=None):

        self.rounds.append({

            "round": round_number,
            "hand_size": hand_size,
            "scores": scores,
            "events": events or [],

        })

    def winner(self):

        return min(

            self.players,

            key=lambda p: p.total_score

        )
