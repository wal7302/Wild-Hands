class_name GameMessage
extends Label

func show_message(text_value: String):
	text = text_value

	var tween := create_tween()
	modulate.a = 0.0
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	tween.tween_interval(1.2)
	tween.tween_property(self, "modulate:a", 0.85, 0.3)
