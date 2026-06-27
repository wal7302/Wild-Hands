from engine.models.player import Player
from engine.game.round import Round
from engine.table.deal_sequence import DealEventType


players = [
    Player("Tasha"),
    Player("Grace"),
]

round_state = Round(
    players,
    cards_dealt=3,
    dealer_name="Grace Lott",
)

round_state.deal()

events = round_state.deal_sequence.events

assert events[0].event_type == DealEventType.SHUFFLE
assert events[-1].event_type == DealEventType.WILD_REVEALED
assert len(players[0].hand) == 3
assert len(players[1].hand) == 3

card_deal_events = [
    event
    for event in events
    if event.event_type == DealEventType.CARD_DEALT
]

assert len(card_deal_events) == 6

print("Round deal sequence test passed.")
