class_name PlayerSeatVisual
extends Node2D

const PLAYER_BADGE_PATH := "res://assets/ui/player_badge.png"
const GRACE_BADGE_PATH := "res://assets/ui/grace_badge.png"

var display_name := ""
var accent_icon := ""

var name_color := Color("#D8A441")
var shadow_color := Color(0, 0, 0, 0.42)

var badge_texture: Texture2D

func configure(
	new_display_name: String,
	new_accent_icon: String = ""
):
	display_name = new_display_name
	accent_icon = new_accent_icon

	load_badge_texture()
	queue_redraw()

func _ready():
	load_badge_texture()
	queue_redraw()

func load_badge_texture():
	badge_texture = null

	if "Grace" in display_name:
		if ResourceLoader.exists(GRACE_BADGE_PATH):
			badge_texture = load(GRACE_BADGE_PATH)
	elif "You" in display_name:
		if ResourceLoader.exists(PLAYER_BADGE_PATH):
			badge_texture = load(PLAYER_BADGE_PATH)

func _draw():
	if badge_texture != null:
		draw_texture_rect(
			badge_texture,
			Rect2(-12, 2, 122, 42),
			false
		)

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
			Vector2.ZERO + Vector2(0, 34),
			accent_icon,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			30,
			name_color
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