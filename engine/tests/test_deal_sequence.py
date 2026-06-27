from engine.table.deal_sequence import DealSequence, DealEventType
from engine.models.card import Card, Suit


sequence = DealSequence()

sequence.shuffle("Grace Lott")

sequence.card_dealt(
    "Tasha",
    Card(7, Suit.HEARTS)
)

sequence.wild_revealed(7)

assert sequence.events[0].event_type == DealEventType.SHUFFLE
assert sequence.events[1].player_name == "Tasha"
assert sequence.events[2].event_type == DealEventType.WILD_REVEALED

print("Deal sequence test passed.")
