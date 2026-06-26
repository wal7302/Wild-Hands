class Achievement:

    def __init__(
        self,
        achievement_id,
        name,
        description,
        reward_type=None,
        reward_id=None,
        hidden=False,
    ):
        self.achievement_id = achievement_id
        self.name = name
        self.description = description
        self.reward_type = reward_type
        self.reward_id = reward_id
        self.hidden = hidden


class AchievementLibrary:

    DEFAULT_ACHIEVEMENTS = [

        Achievement(
            "first_game",
            "Pull Up a Chair",
            "Play your first game of Wild Hands.",
            reward_type="coins",
            reward_id="100",
        ),

        Achievement(
            "first_win",
            "Beginner's Luck",
            "Win your first match.",
            reward_type="coins",
            reward_id="250",
        ),

        Achievement(
            "wild_toss",
            "Wild Toss",
            "Discard a wild card.",
            reward_type="phrase",
            reward_id="phrase_that_was_a_choice",
        ),

        Achievement(
            "butterfingers",
            "Butterfingers",
            "Discard 10 wild cards.",
            reward_type="mug",
            reward_id="mug_professional_wild_tosser",
            hidden=True,
        ),

        Achievement(
            "perfect_hand",
            "Perfect Hand",
            "Finish a round with zero penalty points.",
            reward_type="coins",
            reward_id="500",
        ),
    ]

    @staticmethod
    def all_default():
        return AchievementLibrary.DEFAULT_ACHIEVEMENTS

    @staticmethod
    def find(achievement_id):
        for achievement in AchievementLibrary.DEFAULT_ACHIEVEMENTS:
            if achievement.achievement_id == achievement_id:
                return achievement

        return None
