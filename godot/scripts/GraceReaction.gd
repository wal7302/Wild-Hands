class_name GraceReaction
extends Node2D

var label: Label

func _ready():
	label = Label.new()
	label.text = ""
	label.position = Vector2(-90, 0)
	label.size = Vector2(180, 50)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color("#7A1E2C"))
	add_child(label)

func say(text_value: String):
	label.text = text_value
	label.modulate.a = 0.0

	var tween := create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.2)
	tween.tween_interval(1.4)
	tween.tween_property(label, "modulate:a", 0.0, 0.3)
