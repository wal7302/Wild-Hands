extends Node

const HAND_FILE = "res://data/demo_hand.json"

func load_hand():

	var file = FileAccess.open(HAND_FILE, FileAccess.READ)

	if file == null:
		return []

	var text = file.get_as_text()

	file.close()

	var json = JSON.new()

	if json.parse(text) != OK:
		return []

	return json.data["player_hand"]

func draw_card():

	var cards = load_hand()

	if cards.is_empty():
		return null

	return cards.pop_front()
