from engine.models.player import Player
from engine.directors.dealer_director import DealerDirector


players = [
    Player("Tasha"),
    Player("Grace"),
]

director = DealerDirector()

events = director.start_round(
    players=players,
    hand_size=3,
    wild_rank=3,
)

event_types = [event.event_type for event in events]

assert "dealer.round_start" in event_types
assert "audio.play" in event_types
assert "animation.deal_card" in event_types
assert "dealer.wild_reveal" in event_types

deal_events = [
    event for event in events
    if event.event_type == "animation.deal_card"
]

assert len(deal_events) == 6

print("Dealer director test passed.")
