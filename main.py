from engine.models.player import Player
from engine.game.game import Game
from engine.game.score import ScoreEngine


def show_hand(player):
    return " | ".join(
        f"{index}: {card.display}"
        for index, card in enumerate(player.hand)
    )


def show_discard_pile(round_state):
    if not round_state.discard_pile:
        return "Discard pile is empty."

    return f"Top discard: {round_state.discard_pile[-1].display}"


players = [
    Player("Tasha"),
    Player("Grace"),
]

game = Game(players)
game.start_round()

print("Welcome to Wild Hands")
print(f"Round: {game.round_number}")
print(f"Wild Rank: {game.round.wild_rank}")
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
    print(f"Drew: {drawn.display}")
    print(show_hand(player))

    discard_index = int(input("Choose card index to discard: "))

    discarded = turn.discard(discard_index)

    print(f"Discarded: {discarded.display}")
    print(f"Current score: {ScoreEngine.calculate(player.hand)}")

    game.round.end_turn()

    continue_game = input("Continue? y/n: ").lower().strip()

    if continue_game != "y":
        break

print("Game stopped.")
