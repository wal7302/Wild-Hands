from engine.profile.player_profile import PlayerProfile
from engine.profile.collection_service import CollectionService


profile = PlayerProfile(
    player_id="player_001",
    display_name="Tasha",
    real_first_name="Tasha",
    nickname="Boss Lady",
)

assert profile.display_for_public_game() == "Tasha"
assert profile.display_for_family_club("real_first_name") == "Tasha"
assert profile.display_for_family_club("nickname") == "Boss Lady"

starting_coins = profile.coins

result = CollectionService.purchase_item(
    profile,
    "mug_worlds_okayest"
)

assert result.success is True
assert profile.coins == starting_coins - 100
assert profile.has_collection_item("mugs", "mug_worlds_okayest") is True

print("Profile collection test passed.")
