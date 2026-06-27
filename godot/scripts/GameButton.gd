class_name GameButton
extends Button

var cranberry := Color("#7A1E2C")
var cream := Color("#F4E7D3")

func _ready():
	add_theme_font_size_override("font_size", 18)
	add_theme_color_override("font_color", cream)
