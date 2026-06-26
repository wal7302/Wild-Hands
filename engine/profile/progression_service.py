from engine.profile.progression import ProgressionTable


class ProgressionResult:

    def __init__(self):
        self.levels_gained = []
        self.rewards_unlocked = []


class ProgressionService:

    @staticmethod
    def add_xp(profile, amount):
        result = ProgressionResult()

        profile.xp += amount

        while profile.xp >= ProgressionTable.xp_required_for_level(profile.level):
            profile.xp -= ProgressionTable.xp_required_for_level(profile.level)
            profile.level += 1
            result.levels_gained.append(profile.level)

            rewards = ProgressionTable.rewards_for_level(profile.level)
            result.rewards_unlocked.extend(rewards)

        return result
