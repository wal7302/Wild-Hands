import random


class TableTalkAI:

    @staticmethod
    def should_speak(ai_player):
        personality = getattr(ai_player, "personality", None)

        if personality is None:
            return False

        return random.random() < personality.trash_talk_frequency

    @staticmethod
    def choose_phrase(ai_player):
        personality = getattr(ai_player, "personality", None)

        if personality is None:
            return None

        if not personality.phrases:
            return None

        return random.choice(personality.phrases)
