class_name GameHudVisual
extends Node2D

const HUD_TEXTURE_PATH := "res://assets/ui/game_hud_panel.png"

var panel_size := Vector2(350, 70)

var cranberry := Color("#7A1E2C")
var cranberry_dark := Color("#481019")
var parchment := Color("#F6E4C3")
var parchment_light := Color("#FFF5DF")
var walnut := Color("#4B2919")
var gold := Color("#D8A441")
var text_dark := Color("#3A2015")

var player_name := "Grace"
var wild_text := "Wild = 3"
var round_text := "Round 1"
var turn_text := "Your Turn"

var panel_texture: Texture2D
var turn_tween: Tween

func _ready():
	if ResourceLoader.exists(HUD_TEXTURE_PATH):
		panel_texture = load(HUD_TEXTURE_PATH)

	queue_redraw()

func configure(
	new_player_name: String,
	new_wild_text: String,
	new_round_text: String,
	new_turn_text: String
):
	player_name = new_player_name
	wild_text = new_wild_text
	round_text = new_round_text
	turn_text = new_turn_text
	queue_redraw()

func set_turn_text(new_turn_text: String):
	if turn_text == new_turn_text:
		return

	turn_text = new_turn_text
	queue_redraw()
	animate_turn_change()

func set_wild_text(new_wild_text: String):
	wild_text = new_wild_text
	queue_redraw()

func set_round_text(new_round_text: String):
	round_text = new_round_text
	queue_redraw()

func animate_turn_change():
	if turn_tween != null and turn_tween.is_valid():
		turn_tween.kill()

	scale = Vector2(0.99, 0.99)

	turn_tween = create_tween()
	turn_tween.set_trans(Tween.TRANS_BACK)
	turn_tween.set_ease(Tween.EASE_OUT)

	turn_tween.tween_property(
		self,
		"scale",
		Vector2(1.018, 1.018),
		0.14
	)

	turn_tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.11
	)

func _draw():
	if panel_texture != null:
		draw_texture_rect(
			panel_texture,
			Rect2(Vector2.ZERO, panel_size),
			false
		)
	else:
		draw_fallback_panel()

	draw_string(
		ThemeDB.fallback_font,
		Vector2(18, 27),
		"🍷 " + player_name,
		HORIZONTAL_ALIGNMENT_LEFT,
		108,
		17,
		text_dark
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(121, 27),
		wild_text,
		HORIZONTAL_ALIGNMENT_CENTER,
		108,
		17,
		cranberry
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(239, 27),
		round_text,
		HORIZONTAL_ALIGNMENT_RIGHT,
		92,
		15,
		text_dark
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(18, 57),
		turn_text,
		HORIZONTAL_ALIGNMENT_CENTER,
		314,
		17,
		cranberry_dark
	)

func draw_fallback_panel():
	var shadow_style := StyleBoxFlat.new()
	shadow_style.bg_color = Color(0, 0, 0, 0.30)
	shadow_style.set_corner_radius_all(13)

	draw_style_box(
		shadow_style,
		Rect2(Vector2(5, 6), panel_size)
	)

	var outer_style := StyleBoxFlat.new()
	outer_style.bg_color = walnut
	outer_style.border_color = gold
	outer_style.set_border_width_all(2)
	outer_style.set_corner_radius_all(13)

	draw_style_box(
		outer_style,
		Rect2(Vector2.ZERO, panel_size)
	)

	var inner_style := StyleBoxFlat.new()
	inner_style.bg_color = parchment
	inner_style.border_color = cranberry
	inner_style.set_border_width_all(2)
	inner_style.set_corner_radius_all(9)

	draw_style_box(
		inner_style,
		Rect2(6, 6, 338, 58)
	)

	var turn_style := StyleBoxFlat.new()
	turn_style.bg_color = parchment_light
	turn_style.border_color = gold
	turn_style.set_border_width_all(1)
	turn_style.set_corner_radius_all(7)

	draw_style_box(
		turn_style,
		Rect2(14, 36, 322, 23)
	)

	draw_line(
		Vector2(116, 11),
		Vector2(116, 31),
		gold,
		1
	)

	draw_line(
		Vector2(237, 11),
		Vector2(237, 31),
		gold,
		1
	)