class_name PlayerSeatVisual
extends Node2D

const PLAYER_BADGE_PATH := "res://assets/ui/player_badge.png"
const GRACE_BADGE_PATH := "res://assets/ui/grace_badge.png"

const GRACE_PORTRAIT_PATH := "res://assets/characters/grace_portrait.png"
const PLAYER_PORTRAIT_PATH := "res://assets/characters/player_portrait.png"

var display_name := ""
var accent_icon := ""

var cranberry := Color("#741E2D")
var cranberry_dark := Color("#3A0D16")

var cream := Color("#FFF0D3")
var parchment := Color("#F0D9B5")

var walnut := Color("#3A1D11")
var walnut_light := Color("#68402A")
var walnut_dark := Color("#1E0E08")

var gold := Color("#D7A63C")
var gold_light := Color("#F4D679")
var gold_dark := Color("#875915")

var skin_tone := Color("#B96F4C")
var hair_color := Color("#29150F")
var clothing_color := Color("#7A1E2C")

var badge_texture: Texture2D
var portrait_texture: Texture2D

var is_grace := false
var is_player := false


func configure(
	new_display_name: String,
	new_accent_icon: String = ""
):
	display_name = new_display_name
	accent_icon = new_accent_icon

	resolve_identity()
	load_textures()
	queue_redraw()


func _ready():
	resolve_identity()
	load_textures()
	queue_redraw()


func resolve_identity():
	is_grace = "Grace" in display_name
	is_player = (
		"You" in display_name
		or "Player" in display_name
	)

	if display_name.is_empty():
		if accent_icon == "🍪":
			display_name = "You"
			is_player = true
		elif accent_icon == "🔥":
			display_name = "Grace"
			is_grace = true


func load_textures():
	badge_texture = null
	portrait_texture = null

	if is_grace:
		if ResourceLoader.exists(GRACE_BADGE_PATH):
			badge_texture = load(GRACE_BADGE_PATH)

		if ResourceLoader.exists(GRACE_PORTRAIT_PATH):
			portrait_texture = load(GRACE_PORTRAIT_PATH)

	elif is_player:
		if ResourceLoader.exists(PLAYER_BADGE_PATH):
			badge_texture = load(PLAYER_BADGE_PATH)

		if ResourceLoader.exists(PLAYER_PORTRAIT_PATH):
			portrait_texture = load(PLAYER_PORTRAIT_PATH)


func _draw():
	draw_seat_shadow()
	draw_portrait_frame()

	if portrait_texture != null:
		draw_texture_rect(
			portrait_texture,
			Rect2(6, 6, 64, 64),
			false
		)
	else:
		draw_procedural_portrait()

	draw_nameplate()

	if badge_texture != null:
		draw_texture_rect(
			badge_texture,
			Rect2(76, 13, 96, 36),
			false
		)

	draw_identity_text()
	draw_accent_detail()


func draw_seat_shadow():
	var shadow := StyleBoxFlat.new()
	shadow.bg_color = Color(0, 0, 0, 0.34)
	shadow.set_corner_radius_all(20)

	draw_style_box(
		shadow,
		Rect2(5, 7, 72, 72)
	)


func draw_portrait_frame():
	var outer := StyleBoxFlat.new()
	outer.bg_color = walnut_dark
	outer.border_color = gold_dark
	outer.set_border_width_all(3)
	outer.set_corner_radius_all(22)

	draw_style_box(
		outer,
		Rect2(0, 0, 76, 76)
	)

	var middle := StyleBoxFlat.new()
	middle.bg_color = walnut_light
	middle.border_color = gold
	middle.set_border_width_all(2)
	middle.set_corner_radius_all(19)

	draw_style_box(
		middle,
		Rect2(4, 4, 68, 68)
	)

	var inner := StyleBoxFlat.new()
	inner.bg_color = parchment
	inner.border_color = gold_light
	inner.set_border_width_all(2)
	inner.set_corner_radius_all(17)

	draw_style_box(
		inner,
		Rect2(7, 7, 62, 62)
	)

	draw_arc(
		Vector2(38, 38),
		29,
		0,
		TAU,
		48,
		Color(
			gold_light.r,
			gold_light.g,
			gold_light.b,
			0.55
		),
		1.5
	)


func draw_procedural_portrait():
	var center := Vector2(38, 38)

	draw_circle(
		center,
		28,
		Color("#5A3023")
	)

	draw_circle(
		center + Vector2(0, 2),
		24,
		hair_color
	)

	draw_circle(
		center + Vector2(0, 3),
		17,
		skin_tone
	)

	draw_rect(
		Rect2(23, 50, 30, 16),
		clothing_color
	)

	draw_circle(
		center + Vector2(-6, 1),
		1.7,
		Color("#2A140D")
	)

	draw_circle(
		center + Vector2(6, 1),
		1.7,
		Color("#2A140D")
	)

	draw_arc(
		center + Vector2(0, 4),
		7,
		0.25,
		PI - 0.25,
		12,
		Color("#6E251F"),
		1.5
	)

	if is_grace:
		draw_arc(
			center + Vector2(0, -2),
			19,
			PI,
			TAU,
			24,
			Color("#1E0C08"),
			6
		)

		draw_circle(
			center + Vector2(-17, -12),
			8,
			Color("#1E0C08")
		)

		draw_circle(
			center + Vector2(17, -12),
			8,
			Color("#1E0C08")
		)
	else:
		draw_arc(
			center + Vector2(0, -6),
			18,
			PI,
			TAU,
			24,
			Color("#20110B"),
			5
		)


func draw_nameplate():
	var shadow := StyleBoxFlat.new()
	shadow.bg_color = Color(0, 0, 0, 0.30)
	shadow.set_corner_radius_all(9)

	draw_style_box(
		shadow,
		Rect2(67, 24, 110, 36)
	)

	var wood := StyleBoxFlat.new()
	wood.bg_color = walnut
	wood.border_color = gold_dark
	wood.set_border_width_all(2)
	wood.set_corner_radius_all(9)

	draw_style_box(
		wood,
		Rect2(64, 20, 110, 36)
	)

	var inset := StyleBoxFlat.new()
	inset.bg_color = cranberry
	inset.border_color = gold
	inset.set_border_width_all(2)
	inset.set_corner_radius_all(7)

	draw_style_box(
		inset,
		Rect2(69, 24, 100, 28)
	)

	draw_line(
		Vector2(76, 28),
		Vector2(162, 28),
		Color(
			gold_light.r,
			gold_light.g,
			gold_light.b,
			0.55
		),
		1
	)


func draw_identity_text():
	var final_name := display_name

	if final_name.is_empty():
		final_name = "Player"

	draw_string(
		ThemeDB.fallback_font,
		Vector2(72, 44),
		final_name,
		HORIZONTAL_ALIGNMENT_CENTER,
		94,
		18,
		cream
	)


func draw_accent_detail():
	if accent_icon.is_empty():
		return

	draw_circle(
		Vector2(163, 58),
		12,
		walnut_dark
	)

	draw_circle(
		Vector2(163, 58),
		10,
		gold_dark
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(151, 65),
		accent_icon,
		HORIZONTAL_ALIGNMENT_CENTER,
		24,
		15,
		cream
	)