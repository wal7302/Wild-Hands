class ProgressionReward:

    def __init__(self, level, reward_type, reward_id, description):
        self.level = level
        self.reward_type = reward_type
        self.reward_id = reward_id
        self.description = description


class ProgressionTable:

    REWARDS = [
        ProgressionReward(
            2,
            "phrase",
            "phrase_interesting_strategy",
            "Unlocks the Table Talk phrase: Interesting strategy...",
        ),
        ProgressionReward(
            3,
            "gift",
            "cookies",
            "Unlocks Cookies as a gift.",
        ),
        ProgressionReward(
            5,
            "mug",
            "mug_professional_wild_tosser",
            "Unlocks Professional Wild Tosser mug.",
        ),
        ProgressionReward(
            10,
            "hat",
            "hat_cowboy",
            "Unlocks Cowboy Hat.",
        ),
    ]

    @staticmethod
    def xp_required_for_level(level):
        return level * 100

    @staticmethod
    def rewards_for_level(level):
        return [
            reward
            for reward in ProgressionTable.REWARDS
            if reward.level == level
        ]
