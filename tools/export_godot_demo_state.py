import json
from pathlib import Path


def build_demo_state():
    return {
        "round_number": 1,
        "hand_size": 3,
        "wild_rank": "3",
        "scores": {
            "You": 0,
            "Grace": 0
        },
        "player_hand": [
            {
                "id": "3H",
                "rank": "3",
                "suit": "♥",
                "wild": True
            },
            {
                "id": "7C",
                "rank": "7",
                "suit": "♣",
                "wild": False
            },
            {
                "id": "KD",
                "rank": "K",
                "suit": "♦",
                "wild": False
            }
        ],
        "draw_pile": [
            {
                "id": "8H",
                "rank": "8",
                "suit": "♥",
                "wild": False
            },
            {
                "id": "3S",
                "rank": "3",
                "suit": "♠",
                "wild": True
            },
            {
                "id": "QC",
                "rank": "Q",
                "suit": "♣",
                "wild": False
            },
            {
                "id": "5D",
                "rank": "5",
                "suit": "♦",
                "wild": False
            }
        ],
        "grace_discard": {
            "id": "9C",
            "rank": "9",
            "suit": "♣",
            "wild": False
        }
    }


def main():
    output_path = Path("godot/data/demo_hand.json")
    output_path.parent.mkdir(parents=True, exist_ok=True)

    output_path.write_text(
        json.dumps(build_demo_state(), indent=4),
        encoding="utf-8"
    )

    print(f"Exported Godot demo state to {output_path}")


if __name__ == "__main__":
    main()
