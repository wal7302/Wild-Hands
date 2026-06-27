from engine.models.player import Player
from engine.game.game import Game
from engine.game.events import GameEventType


players = [
    Player("Tasha"),
    Player("Grace"),
]

game = Game(players)

players[0].total_score = 10
players[1].total_score = 20

game.match.add_round(
    3,
    {
        "Tasha": 10,
        "Grace": 20,
    },
    events=[]
)

summary = game.match_results()

assert summary[0]["name"] == "Tasha"
assert summary[0]["total_score"] == 10

print("Match summary test passed.")
