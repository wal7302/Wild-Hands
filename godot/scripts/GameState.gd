class_name GameState

var mode : GameConfig.GameMode

var current_round := 1

var current_hand := 3

var wild_rank := 3

var cards_dealt := 3

var dealer := 0

var current_player := 0

var player_scores = []

func initialize(
	selected_mode:GameConfig.GameMode
):

	mode = selected_mode

	current_hand = GameConfig.first_hand(mode)

	wild_rank = current_hand

	cards_dealt = current_hand

	current_round = 1

	player_scores.clear()

	player_scores.append(0)

	player_scores.append(0)