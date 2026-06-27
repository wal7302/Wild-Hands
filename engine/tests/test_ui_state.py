from engine.models.player import Player
from engine.game.game import Game
from engine.ui_state.game_state import GameState


players = [
    Player("Tasha"),
    Player("Grace"),
]

game = Game(players)
game.start_round()

state = GameState.from_game(
    game,
    current_player_name="Tasha"
)

assert state["round_number"] == 3
assert state["wild_rank"] == 3
assert state["current_player"] == "Tasha"
assert len(state["players"]) == 2
assert "hand" in state["players"][0]
assert "hand" not in state["players"][1]

print("UI state test passed.")
