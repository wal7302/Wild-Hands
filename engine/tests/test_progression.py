from engine.profile.player_profile import PlayerProfile
from engine.profile.progression_service import ProgressionService


profile = PlayerProfile(
    player_id="player_001",
    display_name="Tasha",
)

result = ProgressionService.add_xp(profile, 250)

assert profile.level == 3
assert len(result.levels_gained) == 2
assert result.levels_gained == [2, 3]

reward_ids = [reward.reward_id for reward in result.rewards_unlocked]

assert "phrase_interesting_strategy" in reward_ids
assert "cookies" in reward_ids

print("Progression test passed.")
