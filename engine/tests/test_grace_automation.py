from engine.automation.game_event_bus import GameEventBus
from engine.automation.grace_automation import GraceAutomation
from engine.game.events import EventLog, GameEventType


bus = GameEventBus()
grace = GraceAutomation()

bus.subscribe(GameEventType.WILD_DISCARDED, grace)

event_log = EventLog()

event = event_log.add(
    GameEventType.WILD_DISCARDED,
    player_name="Tasha",
    message="Tasha discarded a wild!"
)

responses = bus.publish(event)

assert len(responses) == 1
assert responses[0].message == "...Honey."
assert responses[0].metadata["animation"] == "sip_wine"

print("Grace automation test passed.")
