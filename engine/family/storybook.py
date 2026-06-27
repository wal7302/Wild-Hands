from dataclasses import dataclass, field
from datetime import datetime


class StorybookEventType:

    GAME_PLAYED = "game_played"
    ROUND_PLAYED = "round_played"
    WILD_DISCARDED = "wild_discarded"
    GIFT_SENT = "gift_sent"
    TOURNAMENT_WON = "tournament_won"
    RECIPE_ADDED = "recipe_added"
    MEMBER_JOINED = "member_joined"


@dataclass
class StorybookEvent:

    event_type: str
    title: str
    description: str
    player_name: str | None = None
    metadata: dict = field(default_factory=dict)
    created_at: datetime = field(default_factory=datetime.now)


class FamilyStorybook:

    def __init__(self, family_club_id):

        self.family_club_id = family_club_id
        self.events = []

    def add_event(
        self,
        event_type,
        title,
        description,
        player_name=None,
        metadata=None,
    ):

        event = StorybookEvent(
            event_type=event_type,
            title=title,
            description=description,
            player_name=player_name,
            metadata=metadata or {},
        )

        self.events.append(event)

        return event

    def recent_events(self, limit=10):

        return sorted(
            self.events,
            key=lambda event: event.created_at,
            reverse=True,
        )[:limit]
