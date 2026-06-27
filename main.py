from engine.models.player import Player
from engine.ai.ai_player import AIPlayer
from engine.game.game import Game
from engine.game.game_modes import GameMode
from engine.game.hand_analyzer import HandAnalyzer
from engine.game.round_reveal import RoundReveal
from engine.game.match_summary import MatchSummary
from engine.commands.command import Command, CommandType
from engine.commands.command_processor import CommandProcessor
from engine.console.console_renderer import ConsoleRenderer
from engine.console.console_input import ConsoleInput


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

game.start_round()

while True:

    while not game.round.finished:

        player = game.round.current_player

        ConsoleRenderer.render_game_state(
            game,
            current_player_name=player.name
        )

        if hasattr(player, "should_speak") and player.should_speak():
            phrase = player.choose_phrase()
            if phrase:
                print(f'{player.name} says: "{phrase}"')

        draw_result = CommandProcessor.process(
            game,
            Command(
                CommandType.DRAW_CARD,
                player.name
            )
        )

        print(draw_result.message)

        if not draw_result.success:
            game.round.finished = True
            break

        ConsoleRenderer.render_game_state(
            game,
            current_player_name=player.name
        )

        if hasattr(player, "choose_discard_index"):
            discard_index = player.choose_discard_index()
            print(f"{player.name} chooses discard index {discard_index}")
        else:
            discard_index = ConsoleInput.ask_discard_index()

        discard_result = CommandProcessor.process(
            game,
            Command(
                CommandType.DISCARD_CARD,
                player.name,
                {"index": discard_index}
            )
        )

        print(discard_result.message)

        if HandAnalyzer.can_go_out(player.hand):
            print(f"{player.name} went out!")
            game.round.mark_player_went_out(player)
            break

        end_turn_result = CommandProcessor.process(
            game,
            Command(
                CommandType.END_TURN,
                player.name
            )
        )

        print(end_turn_result.message)

        if not hasattr(player, "choose_discard_index"):
            if not ConsoleInput.ask_continue():
                game.round.finished = True
                break

    print()
    print("ROUND REVEAL")
    print("----------------------------")

    reveals = RoundReveal.reveal(players)

    for reveal in reveals:
        summary = reveal.summary()

        print(f"{summary['player']}: {summary['score']} points")
        print(f"  Melds: {summary['melds']}")
        print(f"  Penalty Cards: {summary['penalty_cards']}")

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

    if not ConsoleInput.ask_continue("Continue to next round? y/n: "):
        break

    game.next_round()

print()
print("MATCH COMPLETE")
print("----------------------------")

for player in players:
    print(f"{player.name}: {player.total_score}")

print()
print(f"Winner: {game.winner().name}")

summary = MatchSummary.build(game)

print()
print("MATCH HIGHLIGHTS")
print("----------------------------")

if not summary["highlights"]:
    print("No match highlights yet.")
else:
    for highlight in summary["highlights"]:
        print(
            f"{highlight['title']} "
            f"(Round {highlight['round']}): "
            f"{highlight['description']}"
        )

print()
print(f"Wild Toss Count: {summary['wild_toss_count']}")
