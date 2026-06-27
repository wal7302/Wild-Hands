from engine.ui_state.card_state import CardState


class PlayerState:

    @staticmethod
    def from_player(player, include_hand=False):
        state = {
            "name": player.name,
            "total_score": player.total_score,
            "coins": player.coins,
            "xp": player.xp,
            "card_count": len(player.hand),
        }

        if include_hand:
            state["hand"] = [
                CardState.from_card(card, index)
                for index, card in enumerate(player.hand)
            ]

        return state
