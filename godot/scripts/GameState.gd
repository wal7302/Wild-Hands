class_name GameState
extends RefCounted

var mode: GameConfig.GameMode = GameConfig.GameMode.FULL
var mode_name := "Full Game"

var current_round := 1
var total_rounds := 11

var current_hand := 3
var wild_rank := 3
var cards_dealt := 3

var dealer_index := 0
var current_player_index := 1

var player_scores: Array[int] = [0, 0]

var rng := RandomNumberGenerator.new()


func initialize(selected_mode: GameConfig.GameMode):
	rng.randomize()

	mode = selected_mode
	mode_name = GameConfig.mode_display_name(mode)

	current_round = 1
	total_rounds = GameConfig.total_rounds(mode)

	current_hand = GameConfig.hand_value_for_round(
		mode,
		current_round,
		rng
	)

	wild_rank = current_hand
	cards_dealt = current_hand

	dealer_index = 0
	current_player_index = 1
	player_scores = [0, 0]


func advance_round() -> bool:
	if current_round >= total_rounds:
		return false

	current_round += 1

	current_hand = GameConfig.hand_value_for_round(
		mode,
		current_round,
		rng
	)

	wild_rank = current_hand
	cards_dealt = current_hand

	dealer_index = 1 - dealer_index
	current_player_index = 1 - dealer_index

	return true


func add_round_scores(
	player_score: int,
	grace_score: int
):
	player_scores[0] += maxi(player_score, 0)
	player_scores[1] += maxi(grace_score, 0)


func is_game_over() -> bool:
	return current_round >= total_rounds


func winner_text() -> String:
	if player_scores[0] < player_scores[1]:
		return "You win the game!"

	if player_scores[1] < player_scores[0]:
		return "Grace wins the game."

	return "The game ends in a tie."


func wild_label() -> String:
	return GameConfig.rank_label(wild_rank)


func dealer_name() -> String:
	return "Grace" if dealer_index == 0 else "You"


func first_player_name() -> String:
	return "You" if dealer_index == 0 else "Grace"
