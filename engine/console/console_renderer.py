from engine.ui_state.game_state import GameState


class ConsoleRenderer:

    @staticmethod
    def render_game_state(game, current_player_name):

        state = GameState.from_game(
            game,
            current_player_name=current_player_name
        )

        print()
        print("==================================")
        print(f"Round: {state['round_number']}")
        print(f"Wild Rank: {state['wild_rank']}")
        print(f"Current Player: {state['current_player']}")
        print(f"Deck Remaining: {state['deck_remaining']}")
        print("==================================")
        print()

        for player in state["players"]:
            print(
                f"{player['name']} | "
                f"Total Score: {player['total_score']} | "
                f"Cards: {player['card_count']}"
            )

            if "hand" in player:
                print("Hand:")
                for card in player["hand"]:
                    wild_marker = "*" if card["is_wild"] else ""
                    print(
                        f"  {card['index']}: "
                        f"{card['display']}{wild_marker}"
                    )

        if state["discard_top"]:
            print(f"Top Discard: {state['discard_top']['display']}")
        else:
            print("Discard Pile: Empty")
