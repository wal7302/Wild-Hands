from engine.ui_state.card_state import CardState
from engine.ui_state.player_state import PlayerState


class GameState:

    @staticmethod
    def from_game(game, current_player_name=None):
        round_state = game.round

        players = []

        for player in game.players:
            players.append(
                PlayerState.from_player(
                    player,
                    include_hand=player.name == current_player_name
                )
            )

        discard_top = None

        if round_state and round_state.discard_pile:
            discard_top = CardState.from_card(
                round_state.discard_pile[-1]
            )

        return {
            "mode": game.mode,
            "round_number": game.round_number,
            "wild_rank": round_state.wild_rank if round_state else None,
            "current_player": round_state.current_player.name if round_state else None,
            "players": players,
            "discard_top": discard_top,
            "deck_remaining": round_state.deck.remaining() if round_state else 0,
            "turn_count": round_state.turn_count if round_state else 0,
        }
