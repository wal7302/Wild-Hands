from engine.models.player import Player
from engine.game.game import Game
from engine.commands.command import Command, CommandType
from engine.commands.command_processor import CommandProcessor


players = [
    Player("Tasha"),
    Player("Grace"),
]

game = Game(players)
game.start_round()

first_draw = CommandProcessor.process(
    game,
    Command(CommandType.DRAW_CARD, "Tasha")
)

assert first_draw.success is True

second_draw = CommandProcessor.process(
    game,
    Command(CommandType.DRAW_CARD, "Tasha")
)

assert second_draw.success is False

early_end = CommandProcessor.process(
    game,
    Command(CommandType.END_TURN, "Tasha")
)

assert early_end.success is False

discard = CommandProcessor.process(
    game,
    Command(
        CommandType.DISCARD_CARD,
        "Tasha",
        {"index": 0}
    )
)

assert discard.success is True

end_turn = CommandProcessor.process(
    game,
    Command(CommandType.END_TURN, "Tasha")
)

assert end_turn.success is True
assert game.round.current_player.name == "Grace"

print("Turn state test passed.")
