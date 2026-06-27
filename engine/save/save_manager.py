import json
from dataclasses import asdict
from pathlib import Path


class SaveManager:

    @staticmethod
    def save(session, filename):

        Path(filename).parent.mkdir(
            parents=True,
            exist_ok=True
        )

        with open(filename, "w", encoding="utf-8") as f:

            json.dump(
                asdict(session),
                f,
                indent=4,
                default=str,
            )

    @staticmethod
    def load(filename):

        with open(filename, encoding="utf-8") as f:
            return json.load(f)
