class DialogueContext:

    OPENING = "opening"
    SHUFFLE = "shuffle"
    WILD_REVEAL = "wild_reveal"
    WILD_DISCARDED = "wild_discarded"
    PLAYER_WENT_OUT = "player_went_out"
    ROUND_RESULTS = "round_results"
    COMFORT_LOSS = "comfort_loss"
    RETURNING_PLAYER = "returning_player"


class HostDialogueLine:

    def __init__(
        self,
        host_id,
        context,
        text,
        rarity="common",
    ):
        self.host_id = host_id
        self.context = context
        self.text = text
        self.rarity = rarity


class HostDialogueLibrary:

    GRACE_LINES = [

        HostDialogueLine(
            "grace_lott",
            DialogueContext.OPENING,
            "Looks like everyone's here, honey.",
        ),

        HostDialogueLine(
            "grace_lott",
            DialogueContext.OPENING,
            "Grab a seat. I just put the coffee on.",
        ),

        HostDialogueLine(
            "grace_lott",
            DialogueContext.SHUFFLE,
            "Let’s see what the cards have in mind tonight.",
        ),

        HostDialogueLine(
            "grace_lott",
            DialogueContext.WILD_REVEAL,
            "Looks like these are wild tonight.",
        ),

        HostDialogueLine(
            "grace_lott",
            DialogueContext.WILD_DISCARDED,
            "...Honey.",
            rarity="rare",
        ),

        HostDialogueLine(
            "grace_lott",
            DialogueContext.PLAYER_WENT_OUT,
            "Now that was a hand.",
        ),

        HostDialogueLine(
            "grace_lott",
            DialogueContext.COMFORT_LOSS,
            "Keep playing, honey. Your cards are bound to turn around.",
        ),
    ]

    @staticmethod
    def lines_for(host_id, context):
        return [
            line
            for line in HostDialogueLibrary.GRACE_LINES
            if line.host_id == host_id and line.context == context
        ]
