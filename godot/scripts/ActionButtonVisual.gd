class_name ActionButtonVisual
extends Button

var cranberry := Color("#7A1E2C")
var cranberry_dark := Color("#4E111B")
var cream := Color("#F4E7D3")
var gold := Color("#D8A441")

func _ready():
	custom_minimum_size = Vector2(100, 52)
	flat = false

	add_theme_font_size_override("font_size", 18)
	add_theme_color_override("font_color", cream)
	add_theme_color_override("font_hover_color", cream)
	add_theme_color_override("font_pressed_color", gold)
	add_theme_color_override("font_focus_color", gold)

	add_theme_stylebox_override("normal", make_style(cranberry))
	add_theme_stylebox_override("hover", make_style(Color("#8F2637")))
	add_theme_stylebox_override("pressed", make_style(cranberry_dark))
	add_theme_stylebox_override("focus", make_style(cranberry))
	add_theme_stylebox_override("disabled", make_style(Color("#8C7B70")))

func make_style(bg_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = gold
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	style.shadow_color = Color(0, 0, 0, 0.22)
	style.shadow_size = 4
	style.shadow_offset = Vector2(2, 3)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style