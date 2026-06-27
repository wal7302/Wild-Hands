class SimulationStats:

    @staticmethod
    def summarize(games):

        wins = {}
        total_scores = {}
        wild_tosses = 0

        for game in games:

            winner = game.winner().name
            wins[winner] = wins.get(winner, 0) + 1

            for player in game.players:
                total_scores[player.name] = (
                    total_scores.get(player.name, 0)
                    + player.total_score
                )

            for round_record in game.match.rounds:
                for event in round_record.get("events", []):
                    if event.event_type == "wild_discarded":
                        wild_tosses += 1

        game_count = len(games)

        average_scores = {
            name: round(score / game_count, 2)
            for name, score in total_scores.items()
        }

        return {
            "games_played": game_count,
            "wins": wins,
            "average_scores": average_scores,
            "wild_tosses": wild_tosses,
        }
