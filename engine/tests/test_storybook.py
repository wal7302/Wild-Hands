from engine.family.storybook import FamilyStorybook, StorybookEventType


storybook = FamilyStorybook(
    family_club_id="family_001"
)

event = storybook.add_event(
    StorybookEventType.WILD_DISCARDED,
    "Wild Toss!",
    "Tasha discarded a wild and everyone had something to say.",
    player_name="Tasha",
)

assert event.title == "Wild Toss!"
assert len(storybook.events) == 1
assert storybook.recent_events()[0].player_name == "Tasha"

print("Storybook test passed.")
