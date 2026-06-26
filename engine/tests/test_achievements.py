from engine.profile.player_profile import PlayerProfile
from engine.profile.achievement_service import AchievementService


profile = PlayerProfile(
    player_id="player_001",
    display_name="Tasha",
)

result = AchievementService.unlock(profile, "wild_toss")

assert result.unlocked is True
assert "wild_toss" in profile.achievements
assert result.achievement.name == "Wild Toss"

duplicate = AchievementService.unlock(profile, "wild_toss")

assert duplicate.unlocked is False

print("Achievement test passed.")
