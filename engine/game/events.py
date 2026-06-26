from dataclasses import dataclass
from datetime import datetime


class GameEventType:

    WILD_DISCARDED = "wild_discarded"
    PLAYER_WENT_OUT = "player_went_out"
    ROUND_STARTED = "round_started"
    ROUND_ENDED = "round_ended"
    CARD_DRAWN = "card_drawn"
    CARD_DISCARDED = "card_discarded"


@dataclass
class GameEvent:

    event_type: str
    player_name: str | None = None
    message: str | None = None
    metadata: dict | None = None
    created_at: datetime = datetime.now()


class EventLog:

    def __init__(self):

        self.events = []

    def add(self, event_type, player_name=None, message=None, metadata=None):

        event = GameEvent(
            event_type=event_type,
            player_name=player_name,
            message=message,
            metadata=metadata or {}
        )

        self.events.append(event)

        return event

    def highlights(self):

        return [
            event
            for event in self.events
            if event.event_type in [
                GameEventType.WILD_DISCARDED,
                GameEventType.PLAYER_WENT_OUT,
            ]
        ]
