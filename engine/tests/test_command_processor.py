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

draw_result = CommandProcessor.process(
    game,
    Command(
        CommandType.DRAW_CARD,
        "Tasha"
    )
)

assert draw_result.success is True
assert len(players[0].hand) == 4

discard_result = CommandProcessor.process(
    game,
    Command(
        CommandType.DISCARD_CARD,
        "Tasha",
        {"index": 0}
    )
)

assert discard_result.success is True
assert len(players[0].hand) == 3

end_turn_result = CommandProcessor.process(
    game,
    Command(
        CommandType.END_TURN,
        "Tasha"
    )
)

assert end_turn_result.success is True
assert game.round.current_player.name == "Grace"

print("Command processor test passed.")
