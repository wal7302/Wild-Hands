from engine.family.family_club import FamilyClub, FamilyRole


club = FamilyClub(
    club_id="family_001",
    name="The Wild Bunch",
    motto="We came to laugh.",
)

added = club.add_member(
    player_id="player_001",
    role=FamilyRole.HOST
)

assert added is True
assert club.has_member("player_001") is True
assert club.get_member_role("player_001") == FamilyRole.HOST

duplicate = club.add_member("player_001")

assert duplicate is False

print("Family club test passed.")
