from dataclasses import dataclass, field
from datetime import datetime


class ArrivalEventType:
    KNOCK = "knock"
    ENTER_ROOM = "enter_room"
    WAVE = "wave"
    TAKE_SEAT = "take_seat"
    HOST_GREETING = "host_greeting"


@dataclass
class ArrivalEvent:
    event_type: str
    player_name: str | None = None
    message: str | None = None
    created_at: datetime = field(default_factory=datetime.now)


class ArrivalSequence:

    def __init__(self, host_name="Grace Lott"):

        self.host_name = host_name
        self.events = []

    def add_player(self, player_name):

        self.events.append(
            ArrivalEvent(
                ArrivalEventType.KNOCK,
                player_name,
                f"Knock knock. {player_name} is here."
            )
        )

        self.events.append(
            ArrivalEvent(
                ArrivalEventType.ENTER_ROOM,
                player_name,
                f"{player_name} enters the game room."
            )
        )

        self.events.append(
            ArrivalEvent(
                ArrivalEventType.WAVE,
                player_name,
                f"{player_name} waves to the table."
            )
        )

        self.events.append(
            ArrivalEvent(
                ArrivalEventType.TAKE_SEAT,
                player_name,
                f"{player_name} takes their seat."
            )
        )

    def host_greeting(self):

        event = ArrivalEvent(
            ArrivalEventType.HOST_GREETING,
            self.host_name,
            "Looks like everyone's here, honey."
        )

        self.events.append(event)

        return event
