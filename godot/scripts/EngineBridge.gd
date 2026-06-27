extends Node

#
# Temporary bridge.
# Later this will communicate with the Python engine.
#

var demo_deck = [
	{"rank":"3","suit":"♥","wild":true},
	{"rank":"7","suit":"♣","wild":false},
	{"rank":"K","suit":"♦","wild":false},
	{"rank":"5","suit":"♠","wild":false},
	{"rank":"9","suit":"♥","wild":false},
	{"rank":"Q","suit":"♣","wild":false}
]

func draw_card():
	if demo_deck.is_empty():
		return null

	return demo_deck.pop_front()
