from engine.ai.personality import AIPersonality


class PersonalityLibrary:

    TRASH_TALKER = AIPersonality(
        personality_id="trash_talker",
        name="The Trash Talker",
        difficulty="medium",
        description="Talks big, plays bold, and loves a good roast.",
        discard_risk=0.25,
        trash_talk_frequency=0.80,
        gift_frequency=0.20,
        phrases=[
            "Bless your heart.",
            "You call that a hand?",
            "I almost feel bad... almost.",
        ],
    )

    COMPETITIVE_ONE = AIPersonality(
        personality_id="competitive_one",
        name="The Competitive One",
        difficulty="hard",
        description="Focused, efficient, and always trying to win.",
        discard_risk=0.05,
        trash_talk_frequency=0.10,
        gift_frequency=0.05,
        phrases=[
            "Well played.",
            "Good game.",
            "Nice recovery.",
        ],
    )

    DRUNK = AIPersonality(
        personality_id="drunk",
        name="The Drunk",
        difficulty="easy",
        description="Celebrates everything and occasionally makes questionable choices.",
        discard_risk=0.55,
        trash_talk_frequency=0.50,
        gift_frequency=0.70,
        phrases=[
            "I meant to do that.",
            "Who's winning?",
            "That looked important.",
        ],
    )

    JOKESTER = AIPersonality(
        personality_id="jokester",
        name="The Jokester",
        difficulty="medium",
        description="Here for the laughs, snacks, and occasional victory.",
        discard_risk=0.30,
        trash_talk_frequency=0.65,
        gift_frequency=0.55,
        phrases=[
            "I'm just here for the snacks.",
            "Nobody saw that.",
            "That card looked lonely.",
        ],
    )

    CRAZY_ONE = AIPersonality(
        personality_id="crazy_one",
        name="The Crazy One",
        difficulty="medium",
        description="Unpredictable. Sometimes brilliant. Sometimes chaos.",
        discard_risk=0.75,
        trash_talk_frequency=0.60,
        gift_frequency=0.35,
        phrases=[
            "Trust the process.",
            "I have a plan.",
            "No, I will not explain it.",
        ],
    )

    SNEAKY_ONE = AIPersonality(
        personality_id="sneaky_one",
        name="The Sneaky One",
        difficulty="hard",
        description="Quiet until it is too late.",
        discard_risk=0.10,
        trash_talk_frequency=0.15,
        gift_frequency=0.10,
        phrases=[
            "You weren't watching.",
            "Patience.",
            "I've been ready.",
        ],
    )

    SWEETHEART = AIPersonality(
        personality_id="sweetheart",
        name="The Sweetheart",
        difficulty="medium",
        description="Kind, encouraging, and surprisingly hard to beat.",
        discard_risk=0.15,
        trash_talk_frequency=0.00,
        gift_frequency=0.65,
        phrases=[
            "Good luck, honey.",
            "That was a nice play.",
            "You'll get me next time.",
        ],
    )

    @staticmethod
    def all_personalities():
        return [
            PersonalityLibrary.TRASH_TALKER,
            PersonalityLibrary.COMPETITIVE_ONE,
            PersonalityLibrary.DRUNK,
            PersonalityLibrary.JOKESTER,
            PersonalityLibrary.CRAZY_ONE,
            PersonalityLibrary.SNEAKY_ONE,
            PersonalityLibrary.SWEETHEART,
        ]

    @staticmethod
    def find(personality_id):
        for personality in PersonalityLibrary.all_personalities():
            if personality.personality_id == personality_id:
                return personality

        return None
