from engine.ai.ai_player import AIPlayer
from engine.game.game import Game
from engine.game.game_modes import GameMode
from engine.simulation.match_simulator import MatchSimulator
from engine.game.match_summary import MatchSummary


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

completed_game = MatchSimulator.play_match(game)

summary = MatchSummary.build(completed_game)

print("WILD HANDS SIMULATION")
print("----------------------------")

print(f"Winner: {summary['winner']}")
print()

print("Scores:")
for result in summary["results"]:
    print(f"{result['name']}: {result['total_score']}")

print()

print("Highlights:")
if not summary["highlights"]:
    print("No highlights.")
else:
    for highlight in summary["highlights"]:
        print(
            f"{highlight['title']} "
            f"(Round {highlight['round']}): "
            f"{highlight['description']}"
        )

print()
print(f"Wild Toss Count: {summary['wild_toss_count']}")
