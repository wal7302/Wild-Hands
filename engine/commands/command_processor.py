from engine.commands.command import CommandType
from engine.commands.command_result import CommandResult


class CommandProcessor:

    @staticmethod
    def process(game, command):

        round_state = game.round

        if round_state is None:
            return CommandResult(
                False,
                "No active round."
            )

        if round_state.current_player.name != command.player_name:
            return CommandResult(
                False,
                "It is not this player's turn."
            )

        turn = round_state.start_turn()

        if command.command_type == CommandType.DRAW_CARD:
            card = turn.draw()

            if card is None:
                return CommandResult(
                    False,
                    "No card could be drawn."
                )

            return CommandResult(
                True,
                f"{command.player_name} drew a card.",
                {
                    "card": card.display,
                    "is_wild": card.is_wild,
                }
            )

        if command.command_type == CommandType.DISCARD_CARD:
            index = command.payload.get("index")

            if index is None:
                return CommandResult(
                    False,
                    "Discard command requires an index."
                )

            try:
                card = turn.discard(index)
            except IndexError:
                return CommandResult(
                    False,
                    "Invalid discard index."
                )

            return CommandResult(
                True,
                f"{command.player_name} discarded {card.display}.",
                {
                    "card": card.display,
                    "is_wild": card.is_wild,
                }
            )

        if command.command_type == CommandType.SORT_HAND:
            preference = command.payload.get("preference", "manual")
            round_state.current_player.sort_hand(preference)

            return CommandResult(
                True,
                f"{command.player_name} sorted their hand by {preference}."
            )

        if command.command_type == CommandType.END_TURN:
            round_state.end_turn()

            return CommandResult(
                True,
                f"{command.player_name} ended their turn."
            )

        return CommandResult(
            False,
            f"Unknown command type: {command.command_type}"
        )
