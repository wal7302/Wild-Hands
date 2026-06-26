from engine.profile.achievements import AchievementLibrary


class AchievementResult:

    def __init__(self, unlocked=False, achievement=None, message=None):
        self.unlocked = unlocked
        self.achievement = achievement
        self.message = message


class AchievementService:

    @staticmethod
    def ensure_achievement_store(profile):
        if not hasattr(profile, "achievements"):
            profile.achievements = []

    @staticmethod
    def unlock(profile, achievement_id):
        AchievementService.ensure_achievement_store(profile)

        achievement = AchievementLibrary.find(achievement_id)

        if achievement is None:
            return AchievementResult(
                False,
                None,
                f"Achievement '{achievement_id}' does not exist."
            )

        if achievement_id in profile.achievements:
            return AchievementResult(
                False,
                achievement,
                f"{profile.display_name} already unlocked {achievement.name}."
            )

        profile.achievements.append(achievement_id)

        return AchievementResult(
            True,
            achievement,
            f"{profile.display_name} unlocked achievement: {achievement.name}"
        )
