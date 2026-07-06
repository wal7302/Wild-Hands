class_name DeckVisual
extends Node2D

const CardScene := preload("res://scenes/Card.tscn")

var card_visual: Node2D
var shadow_color := Color(0, 0, 0, 0.20)
var edge_color := Color("#3B2114")

func _ready():
	queue_redraw()

	card_visual = CardScene.instantiate()
	card_visual.position = Vector2.ZERO
	card_visual.set_card_back()
	add_child(card_visual)

func _draw():
	draw_rect(Rect2(Vector2(8, 8), Vector2(72, 104)), shadow_color, true)
	draw_rect(Rect2(Vector2(3, 3), Vector2(72, 104)), edge_color, true)