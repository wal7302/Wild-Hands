from engine.models.player import Player
from engine.directors.dealer_director import DealerDirector
from engine.timeline.replay_recorder import ReplayRecorder


players = [
    Player("Tasha"),
    Player("Grace"),
]

dealer = DealerDirector()

director_events = dealer.start_round(
    players=players,
    hand_size=3,
    wild_rank=3,
)

recorder = ReplayRecorder()
timeline = recorder.record_director_events(director_events)

assert len(timeline.events) > 0
assert timeline.events[0].event_type == "dealer.round_start"

deal_events = timeline.by_type("animation.deal_card")

assert len(deal_events) == 6

exported = recorder.export()

assert exported[0]["event_type"] == "dealer.round_start"
assert "timestamp" in exported[0]

print("Event timeline test passed.")
