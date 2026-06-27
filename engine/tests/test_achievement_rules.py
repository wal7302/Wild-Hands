from engine.game.events import EventLog, GameEventType
from engine.profile.player_profile import PlayerProfile
from engine.profile.profile_registry import ProfileRegistry
from engine.profile.event_profile_service import EventProfileService


class FakeRound:

    def __init__(self):
        self.events = EventLog()


profile = PlayerProfile(
    player_id="player_001",
    display_name="Tasha",
)

registry = ProfileRegistry()
registry.add(profile)

round_state = FakeRound()

round_state.events.add(
    GameEventType.WILD_DISCARDED,
    player_name="Tasha",
    message="Tasha discarded a wild."
)

unlocked = EventProfileService.apply_round_events(
    round_state,
    registry
)

assert profile.wilds_discarded == 1
assert "wild_toss" in profile.achievements
assert len(unlocked) == 1

print("Achievement rules test passed.")
