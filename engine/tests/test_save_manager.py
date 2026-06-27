from pathlib import Path

from engine.save.game_session import GameSession
from engine.save.save_manager import SaveManager


session = GameSession()

session.family_name = "Wallace"

session.players = [
    "Tasha",
    "Grace",
    "Rico",
    "Nikki",
]

session.statistics = {
    "games_played": 1,
    "wilds_discarded": 0,
}

filename = "saves/test_session.json"

SaveManager.save(
    session,
    filename,
)

loaded = SaveManager.load(filename)

assert loaded["family_name"] == "Wallace"

assert len(loaded["players"]) == 4

assert loaded["statistics"]["games_played"] == 1

Path(filename).unlink()

print("Save Manager test passed.")
