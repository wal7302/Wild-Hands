from engine.models.player import Player
from engine.directors.dealer_director import DealerDirector
from engine.timeline.replay_recorder import ReplayRecorder
from engine.timeline.timeline_serializer import TimelineSerializer


players = [
    Player("Tasha"),
    Player("Grace"),
    Player("Rico"),
    Player("Nikki"),
]

dealer = DealerDirector()

director_events = dealer.start_round(
    players=players,
    hand_size=3,
    wild_rank=3,
)

recorder = ReplayRecorder()
timeline = recorder.record_director_events(director_events)

TimelineSerializer.save(
    "wildhands_replay.json",
    timeline
)

print("Replay exported to wildhands_replay.json")
