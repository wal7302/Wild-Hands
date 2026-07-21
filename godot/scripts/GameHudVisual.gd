class_name GameHudVisual
extends Node2D

const HUD_TEXTURE_PATH := "res://assets/ui/game_hud_panel.png"

const PANEL_SIZE := Vector2(350, 82)

var cranberry := Color("#741E2D")
var cranberry_dark := Color("#3B0D16")
var cranberry_light := Color("#9B3A4D")

var parchment := Color("#F3DFC0")
var parchment_light := Color("#FFF3DA")
var parchment_dark := Color("#C9A976")

var walnut := Color("#3A1D11")
var walnut_light := Color("#68402A")
var walnut_dark := Color("#1D0D08")

var gold := Color("#D7A63C")
var gold_light := Color("#F3D27A")
var gold_dark := Color("#8D5D15")

var text_dark := Color("#351A10")
var cream := Color("#FFF4DF")

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

	scale = Vector2(0.985, 0.985)
	modulate = Color(1, 1, 1, 0.82)

	turn_tween = create_tween()
	turn_tween.set_trans(Tween.TRANS_BACK)
	turn_tween.set_ease(Tween.EASE_OUT)

	turn_tween.tween_property(
		self,
		"scale",
		Vector2(1.018, 1.018),
		0.14
	)

	turn_tween.parallel().tween_property(
		self,
		"modulate",
		Color.WHITE,
		0.14
	)

	turn_tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.12
	)


func _draw():
	if panel_texture != null:
		draw_texture_rect(
			panel_texture,
			Rect2(Vector2.ZERO, PANEL_SIZE),
			false
		)
	else:
		draw_production_panel()

	draw_top_row()
	draw_turn_banner()


func draw_top_row():
	draw_string(
		ThemeDB.fallback_font,
		Vector2(20, 29),
		player_name,
		HORIZONTAL_ALIGNMENT_LEFT,
		102,
		16,
		text_dark
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(124, 29),
		wild_text,
		HORIZONTAL_ALIGNMENT_CENTER,
		106,
		17,
		cranberry
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(235, 29),
		round_text,
		HORIZONTAL_ALIGNMENT_RIGHT,
		94,
		15,
		text_dark
	)


func draw_turn_banner():
	var turn_color := cranberry_dark

	if "Grace" in turn_text:
		turn_color = walnut
	elif "Complete" in turn_text or "Game Over" in turn_text:
		turn_color = gold_dark
	elif "You" in turn_text:
		turn_color = cranberry_dark

	draw_string(
		ThemeDB.fallback_font,
		Vector2(22, 66),
		turn_text.to_upper(),
		HORIZONTAL_ALIGNMENT_CENTER,
		306,
		20,
		turn_color
	)


func draw_production_panel():
	draw_shadow_layers()
	draw_wood_frame()
	draw_gold_trim()
	draw_parchment_inset()
	draw_header_dividers()
	draw_turn_inset()
	draw_decorative_rivets()


func draw_shadow_layers():
	var large_shadow := StyleBoxFlat.new()
	large_shadow.bg_color = Color(0, 0, 0, 0.26)
	large_shadow.set_corner_radius_all(18)

	draw_style_box(
		large_shadow,
		Rect2(6, 9, PANEL_SIZE.x, PANEL_SIZE.y)
	)

	var close_shadow := StyleBoxFlat.new()
	close_shadow.bg_color = Color(0, 0, 0, 0.18)
	close_shadow.set_corner_radius_all(17)

	draw_style_box(
		close_shadow,
		Rect2(3, 5, PANEL_SIZE.x, PANEL_SIZE.y)
	)


func draw_wood_frame():
	var frame := StyleBoxFlat.new()
	frame.bg_color = walnut
	frame.border_color = walnut_dark
	frame.set_border_width_all(3)
	frame.set_corner_radius_all(17)

	draw_style_box(
		frame,
		Rect2(Vector2.ZERO, PANEL_SIZE)
	)

	var wood_highlight := StyleBoxFlat.new()
	wood_highlight.bg_color = Color(
		walnut_light.r,
		walnut_light.g,
		walnut_light.b,
		0.78
	)

	wood_highlight.set_corner_radius_all(14)

	draw_style_box(
		wood_highlight,
		Rect2(5, 4, PANEL_SIZE.x - 10, 10)
	)


func draw_gold_trim():
	var trim := StyleBoxFlat.new()
	trim.bg_color = Color(0, 0, 0, 0)
	trim.border_color = gold_dark
	trim.set_border_width_all(3)
	trim.set_corner_radius_all(14)

	draw_style_box(
		trim,
		Rect2(5, 5, PANEL_SIZE.x - 10, PANEL_SIZE.y - 10)
	)

	var inner_trim := StyleBoxFlat.new()
	inner_trim.bg_color = Color(0, 0, 0, 0)
	inner_trim.border_color = gold_light
	inner_trim.set_border_width_all(1)
	inner_trim.set_corner_radius_all(12)

	draw_style_box(
		inner_trim,
		Rect2(8, 8, PANEL_SIZE.x - 16, PANEL_SIZE.y - 16)
	)


func draw_parchment_inset():
	var inset := StyleBoxFlat.new()
	inset.bg_color = parchment
	inset.border_color = parchment_dark
	inset.set_border_width_all(2)
	inset.set_corner_radius_all(9)

	draw_style_box(
		inset,
		Rect2(11, 10, PANEL_SIZE.x - 22, 30)
	)

	draw_rect(
		Rect2(14, 12, PANEL_SIZE.x - 28, 4),
		Color(
			parchment_light.r,
			parchment_light.g,
			parchment_light.b,
			0.65
		)
	)


func draw_header_dividers():
	draw_line(
		Vector2(121, 14),
		Vector2(121, 36),
		gold_dark,
		2
	)

	draw_line(
		Vector2(232, 14),
		Vector2(232, 36),
		gold_dark,
		2
	)

	draw_line(
		Vector2(123, 14),
		Vector2(123, 36),
		gold_light,
		1
	)

	draw_line(
		Vector2(234, 14),
		Vector2(234, 36),
		gold_light,
		1
	)


func draw_turn_inset():
	var shadow := StyleBoxFlat.new()
	shadow.bg_color = Color(0, 0, 0, 0.22)
	shadow.set_corner_radius_all(9)

	draw_style_box(
		shadow,
		Rect2(16, 47, PANEL_SIZE.x - 32, 27)
	)

	var banner := StyleBoxFlat.new()
	banner.bg_color = parchment_light
	banner.border_color = cranberry
	banner.set_border_width_all(2)
	banner.set_corner_radius_all(9)

	draw_style_box(
		banner,
		Rect2(14, 44, PANEL_SIZE.x - 28, 27)
	)

	draw_line(
		Vector2(25, 48),
		Vector2(PANEL_SIZE.x - 25, 48),
		Color(
			gold_light.r,
			gold_light.g,
			gold_light.b,
			0.80
		),
		1
	)


func draw_decorative_rivets():
	var rivet_positions := [
		Vector2(10, 10),
		Vector2(PANEL_SIZE.x - 10, 10),
		Vector2(10, PANEL_SIZE.y - 10),
		Vector2(PANEL_SIZE.x - 10, PANEL_SIZE.y - 10)
	]

	for rivet_position: Vector2 in rivet_positions:
		draw_circle(
			rivet_position,
			3.2,
			gold_dark
		)

		draw_circle(
			rivet_position - Vector2(0.6, 0.6),
			1.6,
			gold_light
		)