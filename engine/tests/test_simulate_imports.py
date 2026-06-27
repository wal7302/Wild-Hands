from engine.ai.ai_player import AIPlayer
from engine.game.game import Game
from engine.game.game_modes import GameMode
from engine.simulation.match_simulator import MatchSimulator


players = [
    AIPlayer("Grace", personality="sweetheart"),
    AIPlayer("Rico", personality="trash_talker"),
]

game = Game(
    players,
    mode=GameMode.QUICK,
    starting_round=3,
)

completed_game = MatchSimulator.play_match(game)

assert completed_game is not None
assert completed_game.winner() is not None

print("Simulation imports test passed.")
