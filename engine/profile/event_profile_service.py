from engine.profile.achievement_rules import AchievementRules


class EventProfileService:

    @staticmethod
    def apply_round_events(round_state, profile_registry):

        unlocked_results = []

        for event in round_state.events.events:

            if event.player_name is None:
                continue

            profile = profile_registry.get_by_display_name(
                event.player_name
            )

            if profile is None:
                continue

            unlocked = AchievementRules.evaluate_event(
                profile,
                event
            )

            unlocked_results.extend(unlocked)

        return unlocked_results
