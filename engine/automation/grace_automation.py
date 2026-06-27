from engine.game.events import GameEventType
from engine.automation.automation_response import AutomationResponse


class GraceAutomation:

    source = "grace_lott"

    def handle(self, event):

        if event.event_type == GameEventType.WILD_DISCARDED:
            return AutomationResponse(
                source=self.source,
                action="react",
                message="...Honey.",
                metadata={
                    "animation": "sip_wine",
                    "expression": "side_eye",
                }
            )

        if event.event_type == GameEventType.PLAYER_WENT_OUT:
            return AutomationResponse(
                source=self.source,
                action="congratulate",
                message="Now that was a hand.",
                metadata={
                    "animation": "smile",
                    "expression": "proud",
                }
            )

        if event.event_type == GameEventType.ROUND_STARTED:
            return AutomationResponse(
                source=self.source,
                action="announce",
                message=event.message,
                metadata={
                    "animation": "shuffle_cards",
                    "expression": "warm_smile",
                }
            )

        return None
