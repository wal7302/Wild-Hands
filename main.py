from engine.models.player import Player
from engine.game.game import Game
from engine.game.score import ScoreEngine


def show_hand(player):
    cards = [card.display for card in player.hand]
    return ", ".join(cards)


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
    print(f"Current score: {ScoreEngine.calculate(player.hand)}")
    print()
