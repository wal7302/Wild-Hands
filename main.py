from engine.models.player import Player
from engine.game.game import Game
from engine.game.score import ScoreEngine


def show_hand(player):
    cards = []

    for index, card in enumerate(player.hand):
        cards.append(f"{index}: {card.display}")

    return " | ".join(cards)


def show_discard_pile(round_state):
    if not round_state.discard_pile:
        return "Discard pile is empty."

    top = round_state.discard_pile[-1]
    return f"Top discard: {top.display}"


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

for player in players:
    print(f"{player.name}'s hand:")
    print(show_hand(player))
    print()

turn = game.round.start_turn()

print(f"{game.round.current_player.name}'s turn")
print(show_discard_pile(game.round))

drawn = turn.draw()

print(f"Drew: {drawn.display}")
print(show_hand(game.round.current_player))

discard_index = int(input("Choose card index to discard: "))

discarded = turn.discard(discard_index)

print(f"Discarded: {discarded.display}")
print(show_discard_pile(game.round))

score = ScoreEngine.calculate(game.round.current_player.hand)

print(f"Current hand score: {score}")

game.round.end_turn()

print(f"Next player: {game.round.current_player.name}")
