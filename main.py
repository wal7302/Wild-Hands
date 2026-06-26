from engine.models.player import Player
from engine.ai.ai_player import AIPlayer
from engine.game.game import Game
from engine.game.score import ScoreEngine
from engine.game.hand_analyzer import HandAnalyzer


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
    AIPlayer("Grace", personality="Host"),
]

game = Game(players)
game.start_round()

print("Welcome to Wild Hands")
print(f"Round: {game.round_number}")
print(f"Wild Rank: {game.round.wild_rank}")
print("* means wild")
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

    drawn = turn.draw()

    if drawn is None:
        print("Deck is empty. Round cannot continue yet.")
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
        game.round.finished = True
        break

    print(f"Best score after discard: {ScoreEngine.best_score(player.hand)}")

    game.round.end_turn()

    if not hasattr(player, "choose_discard_index"):
        continue_game = input("Continue? y/n: ").lower().strip()

        if continue_game != "y":
            break

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

winner = min(players, key=lambda p: p.total_score)

print()
print(f"Current Leader: {winner.name}")
