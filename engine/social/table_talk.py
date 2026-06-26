class TableTalkCategory:

    FRIENDLY = "friendly"
    SMACK_TALK = "smack_talk"
    SELF_ROAST = "self_roast"
    REACTION = "reaction"


class TableTalkPhrase:

    def __init__(self, text, category, unlock_level=1):

        self.text = text
        self.category = category
        self.unlock_level = unlock_level


class TableTalkLibrary:

    DEFAULT_PHRASES = [

        TableTalkPhrase("Good luck!", TableTalkCategory.FRIENDLY),
        TableTalkPhrase("Nice hand!", TableTalkCategory.FRIENDLY),
        TableTalkPhrase("Well played!", TableTalkCategory.FRIENDLY),

        TableTalkPhrase("Bless your heart.", TableTalkCategory.SMACK_TALK),
        TableTalkPhrase("You sure about that?", TableTalkCategory.SMACK_TALK),
        TableTalkPhrase("Interesting strategy...", TableTalkCategory.SMACK_TALK),

        TableTalkPhrase("My cards hate me.", TableTalkCategory.SELF_ROAST),
        TableTalkPhrase("I’m just here for the snacks.", TableTalkCategory.SELF_ROAST),

        TableTalkPhrase("Thanks for the wild!", TableTalkCategory.REACTION),
        TableTalkPhrase("That was a choice.", TableTalkCategory.REACTION),
    ]

    @staticmethod
    def all_default():

        return TableTalkLibrary.DEFAULT_PHRASES

    @staticmethod
    def wild_toss_reactions():

        return [
            phrase
            for phrase in TableTalkLibrary.DEFAULT_PHRASES
            if phrase.text in [
                "Thanks for the wild!",
                "You sure about that?",
                "That was a choice.",
            ]
        ]
