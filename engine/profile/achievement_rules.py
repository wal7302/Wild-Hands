from engine.game.events import GameEventType
from engine.profile.achievement_service import AchievementService


class AchievementRules:

    @staticmethod
    def evaluate_event(profile, event):

        unlocked = []

        if event.event_type == GameEventType.WILD_DISCARDED:
            profile.wilds_discarded += 1

            first = AchievementService.unlock(
                profile,
                "wild_toss"
            )

            if first.unlocked:
                unlocked.append(first)

            if profile.wilds_discarded >= 10:
                butterfingers = AchievementService.unlock(
                    profile,
                    "butterfingers"
                )

                if butterfingers.unlocked:
                    unlocked.append(butterfingers)

        if event.event_type == GameEventType.PLAYER_WENT_OUT:
            perfect = AchievementService.unlock(
                profile,
                "perfect_hand"
            )

            if perfect.unlocked:
                unlocked.append(perfect)

        return unlocked
