from dataclasses import dataclass, field
from datetime import datetime


class DealEventType:

    SHUFFLE = "shuffle"
    CARD_DEALT = "card_dealt"
    WILD_REVEALED = "wild_revealed"


@dataclass
class DealEvent:

    event_type: str
    player_name: str | None = None
    card_display: str | None = None
    message: str | None = None
    created_at: datetime = field(default_factory=datetime.now)


class DealSequence:

    def __init__(self):

        self.events = []

    def shuffle(self, dealer_name):

        self.events.append(
            DealEvent(
                DealEventType.SHUFFLE,
                message=f"{dealer_name} shuffles the deck."
            )
        )

    def card_dealt(self, player_name, card):

        self.events.append(
            DealEvent(
                DealEventType.CARD_DEALT,
                player_name=player_name,
                card_display=card.display,
                message=f"Card dealt to {player_name}."
            )
        )

    def wild_revealed(self, wild_rank):

        self.events.append(
            DealEvent(
                DealEventType.WILD_REVEALED,
                message=f"{wild_rank}s are wild."
            )
        )
