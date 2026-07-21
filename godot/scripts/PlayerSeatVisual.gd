class_name PlayerSeatVisual
extends Node2D

const PLAYER_BADGE_PATH: String = (
	"res://assets/ui/player_badge.png"
)

const GRACE_BADGE_PATH: String = (
	"res://assets/ui/grace_badge.png"
)

const GRACE_PORTRAIT_PATH: String = (
	"res://assets/characters/grace_portrait.png"
)

const PLAYER_PORTRAIT_PATH: String = (
	"res://assets/characters/player_portrait.png"
)

var display_name: String = ""
var accent_icon: String = ""

var cranberry: Color = Color("#741E2D")
var cranberry_dark: Color = Color("#3A0D16")

var cream: Color = Color("#FFF0D3")
var parchment: Color = Color("#EBD4AD")

var walnut: Color = Color("#3A1D11")
var walnut_light: Color = Color("#68402A")
var walnut_dark: Color = Color("#170A06")

var gold: Color = Color("#D7A63C")
var gold_light: Color = Color("#F4D679")
var gold_dark: Color = Color("#875915")

var skin_tone: Color = Color("#B96F4C")
var hair_color: Color = Color("#29150F")
var clothing_color: Color = Color("#7A1E2C")

var badge_texture: Texture2D
var portrait_texture: Texture2D

var is_grace: bool = false
var is_player: bool = false


func configure(
	new_display_name: String,
	new_accent_icon: String = ""
) -> void:
	display_name = new_display_name
	accent_icon = new_accent_icon

	resolve_identity()
	load_textures()
	queue_redraw()


func _ready() -> void:
	resolve_identity()
	load_textures()
	queue_redraw()


func resolve_identity() -> void:
	is_grace = display_name.contains("Grace")

	is_player = (
		display_name.contains("You")
		or display_name.contains("Player")
	)

	if display_name.is_empty():
		display_name = "Player"
		is_player = true


func load_textures() -> void:
	badge_texture = null
	portrait_texture = null

	if is_grace:
		if ResourceLoader.exists(GRACE_BADGE_PATH):
			badge_texture = (
				load(GRACE_BADGE_PATH) as Texture2D
			)

		if ResourceLoader.exists(GRACE_PORTRAIT_PATH):
			portrait_texture = (
				load(GRACE_PORTRAIT_PATH) as Texture2D
			)

	elif is_player:
		if ResourceLoader.exists(PLAYER_BADGE_PATH):
			badge_texture = (
				load(PLAYER_BADGE_PATH) as Texture2D
			)

		if ResourceLoader.exists(PLAYER_PORTRAIT_PATH):
			portrait_texture = (
				load(PLAYER_PORTRAIT_PATH) as Texture2D
			)


func _draw() -> void:
	draw_seat_shadow()
	draw_portrait_frame()
	draw_procedural_portrait()
	draw_nameplate()
	draw_identity_text()
	draw_accent_detail()


func draw_seat_shadow() -> void:
	var shadow: StyleBoxFlat = StyleBoxFlat.new()
	shadow.bg_color = Color(0.0, 0.0, 0.0, 0.42)
	shadow.set_corner_radius_all(22)

	draw_style_box(
		shadow,
		Rect2(5.0, 7.0, 74.0, 74.0)
	)


func draw_portrait_frame() -> void:
	var outer: StyleBoxFlat = StyleBoxFlat.new()
	outer.bg_color = walnut_dark
	outer.border_color = gold_dark
	outer.set_border_width_all(3)
	outer.set_corner_radius_all(23)

	draw_style_box(
		outer,
		Rect2(0.0, 0.0, 78.0, 78.0)
	)

	var middle: StyleBoxFlat = StyleBoxFlat.new()
	middle.bg_color = walnut
	middle.border_color = gold
	middle.set_border_width_all(2)
	middle.set_corner_radius_all(20)

	draw_style_box(
		middle,
		Rect2(4.0, 4.0, 70.0, 70.0)
	)

	var inner: StyleBoxFlat = StyleBoxFlat.new()
	inner.bg_color = parchment
	inner.border_color = gold_light
	inner.set_border_width_all(2)
	inner.set_corner_radius_all(17)

	draw_style_box(
		inner,
		Rect2(7.0, 7.0, 64.0, 64.0)
	)

	draw_arc(
		Vector2(39.0, 39.0),
		30.0,
		0.0,
		TAU,
		48,
		Color(
			gold_light.r,
			gold_light.g,
			gold_light.b,
			0.60
		),
		1.5
	)


func draw_procedural_portrait() -> void:
	var center: Vector2 = Vector2(39.0, 39.0)

	draw_circle(
		center,
		28.0,
		Color("#573022")
	)

	draw_circle(
		center + Vector2(0.0, 2.0),
		24.0,
		hair_color
	)

	draw_circle(
		center + Vector2(0.0, 3.0),
		17.0,
		skin_tone
	)

	draw_rect(
		Rect2(24.0, 51.0, 30.0, 16.0),
		clothing_color
	)

	draw_circle(
		center + Vector2(-6.0, 1.0),
		1.7,
		Color("#2A140D")
	)

	draw_circle(
		center + Vector2(6.0, 1.0),
		1.7,
		Color("#2A140D")
	)

	draw_arc(
		center + Vector2(0.0, 4.0),
		7.0,
		0.25,
		PI - 0.25,
		12,
		Color("#6E251F"),
		1.5
	)

	if is_grace:
		draw_arc(
			center + Vector2(0.0, -2.0),
			19.0,
			PI,
			TAU,
			24,
			Color("#1E0C08"),
			6.0
		)

		draw_circle(
			center + Vector2(-17.0, -12.0),
			8.0,
			Color("#1E0C08")
		)

		draw_circle(
			center + Vector2(17.0, -12.0),
			8.0,
			Color("#1E0C08")
		)


func draw_nameplate() -> void:
	var shadow: StyleBoxFlat = StyleBoxFlat.new()
	shadow.bg_color = Color(0.0, 0.0, 0.0, 0.38)
	shadow.set_corner_radius_all(10)

	draw_style_box(
		shadow,
		Rect2(68.0, 25.0, 113.0, 38.0)
	)

	var outer: StyleBoxFlat = StyleBoxFlat.new()
	outer.bg_color = walnut_dark
	outer.border_color = gold_dark
	outer.set_border_width_all(2)
	outer.set_corner_radius_all(10)

	draw_style_box(
		outer,
		Rect2(64.0, 20.0, 113.0, 38.0)
	)

	var inset: StyleBoxFlat = StyleBoxFlat.new()
	inset.bg_color = cranberry_dark
	inset.border_color = gold
	inset.set_border_width_all(2)
	inset.set_corner_radius_all(8)

	draw_style_box(
		inset,
		Rect2(69.0, 24.0, 103.0, 30.0)
	)

	draw_rect(
		Rect2(75.0, 27.0, 91.0, 3.0),
		Color(
			cranberry.r,
			cranberry.g,
			cranberry.b,
			0.90
		)
	)

	draw_line(
		Vector2(77.0, 29.0),
		Vector2(164.0, 29.0),
		Color(
			gold_light.r,
			gold_light.g,
			gold_light.b,
			0.60
		),
		1.0
	)


func draw_identity_text() -> void:
	var final_name: String = display_name

	if final_name.is_empty():
		final_name = "Player"

	draw_string(
		ThemeDB.fallback_font,
		Vector2(73.0, 46.0),
		final_name,
		HORIZONTAL_ALIGNMENT_CENTER,
		95.0,
		18,
		cream
	)


func draw_accent_detail() -> void:
	if accent_icon.is_empty():
		return

	draw_circle(
		Vector2(166.0, 60.0),
		11.0,
		walnut_dark
	)

	draw_circle(
		Vector2(166.0, 60.0),
		9.0,
		gold_dark
	)

	draw_circle(
		Vector2(166.0, 60.0),
		7.5,
		cranberry
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(154.0, 66.0),
		accent_icon,
		HORIZONTAL_ALIGNMENT_CENTER,
		24.0,
		14,
		cream
	)