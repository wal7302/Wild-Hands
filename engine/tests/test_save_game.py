from pathlib import Path

from engine.persistence.save_game import SaveGame


filename = "test_save.json"

SaveGame.save(

    filename,

    {

        "round": 5,

        "winner": "Grace"

    }

)

loaded = SaveGame.load(filename)

assert loaded["version"] == "0.1"

assert loaded["game"]["winner"] == "Grace"

Path(filename).unlink()

print("Save game test passed.")
