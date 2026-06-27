import json
from pathlib import Path


class SaveGame:

    SAVE_VERSION = "0.1"

    @staticmethod
    def save(filename, data):

        payload = {
            "version": SaveGame.SAVE_VERSION,
            "game": data
        }

        path = Path(filename)

        path.write_text(
            json.dumps(payload, indent=4),
            encoding="utf-8"
        )

    @staticmethod
    def load(filename):

        path = Path(filename)

        if not path.exists():
            return None

        return json.loads(
            path.read_text(encoding="utf-8")
        )
