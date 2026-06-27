from dataclasses import dataclass, field


class CommandType:

    DRAW_CARD = "draw_card"
    DISCARD_CARD = "discard_card"
    SORT_HAND = "sort_hand"
    SEND_GIFT = "send_gift"
    SAY_TABLE_TALK = "say_table_talk"
    END_TURN = "end_turn"


@dataclass
class Command:

    command_type: str
    player_name: str
    payload: dict = field(default_factory=dict)
