extends Node

const HAND_FILE := "res://data/demo_hand.json"

var game_state := {}
var draw_pile := []

func _ready():
	load_game_state()

func load_game_state():
	var file := FileAccess.open(HAND_FILE, FileAccess.READ)

	if file == null:
		game_state = {}
		draw_pile = []
		return

	var text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var parse_result := json.parse(text)

	if parse_result != OK:
		game_state = {}
		draw_pile = []
		return

	game_state = json.data
	draw_pile = game_state.get("draw_pile", []).duplicate(true)

func get_round_number():
	return game_state.get("round_number", 1)

func get_hand_size():
	return game_state.get("hand_size", 3)

func get_wild_rank():
	return game_state.get("wild_rank", "3")

func get_scores():
	return game_state.get("scores", {"You": 0, "Grace": 0})

func get_player_hand():
	return game_state.get("player_hand", [])

func draw_card():
	if draw_pile.is_empty():
		return null

	return draw_pile.pop_front()

func get_grace_discard():
	return game_state.get("grace_discard", {
		"id": "9C",
		"rank": "9",
		"suit": "♣",
		"wild": false
	})
