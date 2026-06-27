class_name HandVisual
extends Node2D

var hand_label: Label

func _ready():
	visible = false

	hand_label = Label.new()
	hand_label.text = "🤚"
	hand_label.position = Vector2(-18, -18)
	hand_label.add_theme_font_size_override("font_size", 34)
	add_child(hand_label)

func show_hand(start_position: Vector2):
	global_position = start_position
	visible = true

func hide_hand():
	visible = false

func move_to(target_position: Vector2, duration: float = 0.3):
	var tween := create_tween()
	tween.tween_property(self, "global_position", target_position, duration)
	return tween
