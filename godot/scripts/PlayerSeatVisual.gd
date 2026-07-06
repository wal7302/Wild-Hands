class_name PlayerSeatVisual
extends Node2D

var display_name := ""
var accent_icon := ""
var name_color := Color("#D8A441")
var icon_color := Color("#7A1E2C")
var shadow_color := Color(0, 0, 0, 0.28)

func configure(new_display_name: String, new_accent_icon: String = ""):
	display_name = new_display_name
	accent_icon = new_accent_icon
	queue_redraw()

func _ready():
	queue_redraw()

func _draw():
	if accent_icon != "":
		draw_string(
			ThemeDB.fallback_font,
			Vector2(2, 36),
			accent_icon,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			30,
			shadow_color
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(0, 34),
			accent_icon,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			30,
			icon_color
		)

	if display_name != "":
		draw_string(
			ThemeDB.fallback_font,
			Vector2(2, 36),
			display_name,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			shadow_color
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(0, 34),
			display_name,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			name_color
		)