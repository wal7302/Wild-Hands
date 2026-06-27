from pathlib import Path

from engine.models.player import Player
from engine.directors.dealer_director import DealerDirector
from engine.timeline.replay_recorder import ReplayRecorder
from engine.timeline.timeline_serializer import TimelineSerializer


players = [
    Player("Tasha"),
    Player("Grace"),
]

dealer = DealerDirector()

events = dealer.start_round(
    players=players,
    hand_size=3,
    wild_rank=3,
)

recorder = ReplayRecorder()
timeline = recorder.record_director_events(events)

filename = "test_replay.json"

TimelineSerializer.save(filename, timeline)

path = Path(filename)

assert path.exists()
assert "animation.deal_card" in path.read_text(encoding="utf-8")

path.unlink()

print("Timeline serializer test passed.")
