from engine.commands.command import Command, CommandType
from engine.commands.command_processor import CommandProcessor
from engine.game.hand_analyzer import HandAnalyzer


class MatchSimulator:

    @staticmethod
    def play_match(game, max_turns_per_round=200):

        game.start_round()

        while True:

            turns_this_round = 0

            while not game.round.finished:

                turns_this_round += 1

                if turns_this_round > max_turns_per_round:
                    game.round.finished = True
                    break

                player = game.round.current_player

                draw_result = CommandProcessor.process(
                    game,
                    Command(
                        CommandType.DRAW_CARD,
                        player.name
                    )
                )

                if not draw_result.success:
                    game.round.finished = True
                    break

                if hasattr(player, "choose_discard_index"):
                    discard_index = player.choose_discard_index()
                else:
                    discard_index = 0

                discard_result = CommandProcessor.process(
                    game,
                    Command(
                        CommandType.DISCARD_CARD,
                        player.name,
                        {"index": discard_index}
                    )
                )

                if not discard_result.success:
                    game.round.finished = True
                    break

                if HandAnalyzer.can_go_out(player.hand):
                    game.round.mark_player_went_out(player)
                    break

                end_turn_result = CommandProcessor.process(
                    game,
                    Command(
                        CommandType.END_TURN,
                        player.name
                    )
                )

                if not end_turn_result.success:
                    game.round.finished = True
                    break

            game.end_round()

            if not game.has_next_round():
                break

            game.next_round()

        return game
