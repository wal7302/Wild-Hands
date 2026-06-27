from engine.ai.ai_player import AIPlayer
from engine.game.game import Game
from engine.game.game_modes import GameMode
from engine.simulation.match_simulator import MatchSimulator
from engine.simulation.simulation_stats import SimulationStats


games = []

for _ in range(100):

    players = [
        AIPlayer("Grace", personality="sweetheart"),
        AIPlayer("Rico", personality="trash_talker"),
        AIPlayer("Nikki", personality="sneaky_one"),
        AIPlayer("Lulu", personality="crazy_one"),
    ]

    game = Game(
        players,
        mode=GameMode.QUICK,
        starting_round=3,
    )

    games.append(
        MatchSimulator.play_match(game)
    )


stats = SimulationStats.summarize(games)

print("WILD HANDS BALANCE SIMULATION")
print("-----------------------------")
print(f"Games Played: {stats['games_played']}")
print()
print("Wins:")
for name, wins in stats["wins"].items():
    print(f"{name}: {wins}")

print()
print("Average Scores:")
for name, score in stats["average_scores"].items():
    print(f"{name}: {score}")

print()
print(f"Wild Tosses: {stats['wild_tosses']}")
