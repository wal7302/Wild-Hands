from engine.models.player import Player
from engine.ai.ai_player import AIPlayer
from engine.game.game import Game
from engine.game.game_modes import GameMode
from engine.game.score import ScoreEngine
from engine.game.hand_analyzer import HandAnalyzer
from engine.persistence.game_serializer import GameSerializer
from engine.persistence.save_game import SaveGame

def show_hand(player):
    return " | ".join(
        f"{index}: {card.display}{'*' if card.is_wild else ''}"
        for index, card in enumerate(player.hand)
    )


def show_discard_pile(round_state):
    if not round_state.discard_pile:
        return "Discard pile is empty."

    return f"Top discard: {round_state.discard_pile[-1].display}"


players = [
    Player("Tasha"),
    AIPlayer("Grace", personality="sweetheart"),
    AIPlayer("Rico", personality="trash_talker"),
]

game = Game(
    players,
    mode=GameMode.QUICK,
    starting_round=3
)

print("Welcome to Wild Hands")
print("* means wild")
print()

game.start_round()

while True:

    print()
    print("==================================")
    print(f"ROUND {game.round_number}")
    print(f"Wild Rank: {game.round.wild_rank}")
    print("==================================")
    print()

    while not game.round.finished:

        player = game.round.current_player
        turn = game.round.start_turn()

        print("----------------------------------")
        print(f"{player.name}'s turn")
        print(show_discard_pile(game.round))
        print()
        print("Hand:")
        print(show_hand(player))

        if hasattr(player, "should_speak") and player.should_speak():
            phrase = player.choose_phrase()
            if phrase:
                print(f'{player.name} says: "{phrase}"')

        drawn = turn.draw()

        if drawn is None:
            print("Deck is empty. Round cannot continue yet.")
            game.round.finished = True
            break

        print()
        print(f"Drew: {drawn.display}{'*' if drawn.is_wild else ''}")
        print(show_hand(player))

        print(f"Best current score: {ScoreEngine.best_score(player.hand)}")

        if hasattr(player, "choose_discard_index"):
            discard_index = player.choose_discard_index()
            print(f"{player.name} chooses to discard index {discard_index}")
        else:
            discard_index = int(input("Choose card index to discard: "))

        discarded = turn.discard(discard_index)

        print(f"Discarded: {discarded.display}{'*' if discarded.is_wild else ''}")

        if HandAnalyzer.can_go_out(player.hand):
            print(f"{player.name} went out!")
            game.round.mark_player_went_out(player)
            break

        print(f"Best score after discard: {ScoreEngine.best_score(player.hand)}")

        game.round.end_turn()

        if not hasattr(player, "choose_discard_index"):
            continue_game = input("Continue? y/n: ").lower().strip()

            if continue_game != "y":
                game.round.finished = True
                break

    print()
    print("ROUND HIGHLIGHTS")
    print("----------------------------")

    highlights = game.round.events.highlights()

    if not highlights:
        print("No major highlights this round.")
    else:
        for event in highlights:
            print(event.message)

    print()
    print("ROUND RESULTS")
    print("----------------------------")

    scores = game.end_round()

    for player in players:
        print(
            f"{player.name}: "
            f"Round={scores[player.name]} "
            f"Total={player.total_score}"
        )

    if not game.has_next_round():
        break

    continue_match = input("Continue to next round? y/n: ").lower().strip()

    if continue_match != "y":
        break

    game.next_round()

print()
print("MATCH COMPLETE")
print("----------------------------")

for player in players:
    print(f"{player.name}: {player.total_score}")

print()
print(f"Winner: {game.winner().name}")

SaveGame.save(
    "last_game.json",
    GameSerializer.serialize(game)
)

print()
print("Game saved successfully.")
