class_name GameHudVisual
extends Node2D

const HUD_TEXTURE_PATH: String = (
	"res://assets/ui/game_hud_panel.png"
)

const PANEL_SIZE: Vector2 = Vector2(350.0, 86.0)

var cranberry: Color = Color("#741E2D")
var cranberry_dark: Color = Color("#3B0D16")
var cranberry_light: Color = Color("#A64759")

var parchment: Color = Color("#EBD5AF")
var parchment_light: Color = Color("#FFF0D0")
var parchment_dark: Color = Color("#B99156")

var walnut: Color = Color("#3A1D11")
var walnut_light: Color = Color("#65402A")
var walnut_dark: Color = Color("#170A06")

var gold: Color = Color("#D7A63C")
var gold_light: Color = Color("#F3D27A")
var gold_dark: Color = Color("#80520F")

var text_dark: Color = Color("#351A10")
var cream: Color = Color("#FFF4DF")

var player_name: String = "Grace"
var wild_text: String = "Wild = 3"
var round_text: String = "Round 1"
var turn_text: String = "Your Turn"

var panel_texture: Texture2D
var turn_tween: Tween


func _ready() -> void:
	if ResourceLoader.exists(HUD_TEXTURE_PATH):
		panel_texture = load(HUD_TEXTURE_PATH) as Texture2D

	queue_redraw()


func configure(
	new_player_name: String,
	new_wild_text: String,
	new_round_text: String,
	new_turn_text: String
) -> void:
	player_name = new_player_name
	wild_text = new_wild_text
	round_text = new_round_text
	turn_text = new_turn_text

	queue_redraw()


func set_turn_text(new_turn_text: String) -> void:
	if turn_text == new_turn_text:
		return

	turn_text = new_turn_text
	queue_redraw()
	animate_turn_change()


func set_wild_text(new_wild_text: String) -> void:
	wild_text = new_wild_text
	queue_redraw()


func set_round_text(new_round_text: String) -> void:
	round_text = new_round_text
	queue_redraw()


func animate_turn_change() -> void:
	if turn_tween != null and turn_tween.is_valid():
		turn_tween.kill()

	scale = Vector2(0.985, 0.985)
	modulate = Color(1.0, 1.0, 1.0, 0.82)

	turn_tween = create_tween()
	turn_tween.set_trans(Tween.TRANS_BACK)
	turn_tween.set_ease(Tween.EASE_OUT)

	turn_tween.tween_property(
		self,
		"scale",
		Vector2(1.015, 1.015),
		0.13
	)

	turn_tween.parallel().tween_property(
		self,
		"modulate",
		Color.WHITE,
		0.13
	)

	turn_tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.11
	)


func _draw() -> void:
	draw_production_panel()
	draw_top_row()
	draw_turn_banner()


func draw_production_panel() -> void:
	draw_shadow_layers()
	draw_outer_wood()
	draw_gold_trim()
	draw_information_inset()
	draw_header_dividers()
	draw_turn_inset()
	draw_decorative_rivets()


func draw_shadow_layers() -> void:
	var shadow: StyleBoxFlat = StyleBoxFlat.new()
	shadow.bg_color = Color(0.0, 0.0, 0.0, 0.42)
	shadow.set_corner_radius_all(16)

	draw_style_box(
		shadow,
		Rect2(5.0, 7.0, PANEL_SIZE.x, PANEL_SIZE.y)
	)

	var close_shadow: StyleBoxFlat = StyleBoxFlat.new()
	close_shadow.bg_color = Color(0.0, 0.0, 0.0, 0.22)
	close_shadow.set_corner_radius_all(15)

	draw_style_box(
		close_shadow,
		Rect2(2.0, 3.0, PANEL_SIZE.x, PANEL_SIZE.y)
	)


func draw_outer_wood() -> void:
	var outer: StyleBoxFlat = StyleBoxFlat.new()
	outer.bg_color = walnut_dark
	outer.border_color = gold_dark
	outer.set_border_width_all(3)
	outer.set_corner_radius_all(16)

	draw_style_box(
		outer,
		Rect2(Vector2.ZERO, PANEL_SIZE)
	)

	var wood: StyleBoxFlat = StyleBoxFlat.new()
	wood.bg_color = walnut
	wood.border_color = walnut_light
	wood.set_border_width_all(2)
	wood.set_corner_radius_all(13)

	draw_style_box(
		wood,
		Rect2(
			4.0,
			4.0,
			PANEL_SIZE.x - 8.0,
			PANEL_SIZE.y - 8.0
		)
	)

	draw_rect(
		Rect2(9.0, 7.0, PANEL_SIZE.x - 18.0, 4.0),
		Color(
			walnut_light.r,
			walnut_light.g,
			walnut_light.b,
			0.75
		)
	)


func draw_gold_trim() -> void:
	var trim: StyleBoxFlat = StyleBoxFlat.new()
	trim.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	trim.border_color = gold
	trim.set_border_width_all(2)
	trim.set_corner_radius_all(12)

	draw_style_box(
		trim,
		Rect2(
			7.0,
			7.0,
			PANEL_SIZE.x - 14.0,
			PANEL_SIZE.y - 14.0
		)
	)

	var highlight: StyleBoxFlat = StyleBoxFlat.new()
	highlight.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	highlight.border_color = gold_light
	highlight.set_border_width_all(1)
	highlight.set_corner_radius_all(10)

	draw_style_box(
		highlight,
		Rect2(
			10.0,
			10.0,
			PANEL_SIZE.x - 20.0,
			PANEL_SIZE.y - 20.0
		)
	)


func draw_information_inset() -> void:
	var inset_shadow: StyleBoxFlat = StyleBoxFlat.new()
	inset_shadow.bg_color = Color(0.0, 0.0, 0.0, 0.30)
	inset_shadow.set_corner_radius_all(8)

	draw_style_box(
		inset_shadow,
		Rect2(14.0, 13.0, PANEL_SIZE.x - 28.0, 30.0)
	)

	var inset: StyleBoxFlat = StyleBoxFlat.new()
	inset.bg_color = parchment
	inset.border_color = parchment_dark
	inset.set_border_width_all(2)
	inset.set_corner_radius_all(8)

	draw_style_box(
		inset,
		Rect2(12.0, 10.0, PANEL_SIZE.x - 24.0, 30.0)
	)

	draw_rect(
		Rect2(17.0, 13.0, PANEL_SIZE.x - 34.0, 3.0),
		Color(
			parchment_light.r,
			parchment_light.g,
			parchment_light.b,
			0.80
		)
	)


func draw_header_dividers() -> void:
	draw_line(
		Vector2(116.0, 14.0),
		Vector2(116.0, 36.0),
		gold_dark,
		2.0
	)

	draw_line(
		Vector2(234.0, 14.0),
		Vector2(234.0, 36.0),
		gold_dark,
		2.0
	)

	draw_line(
		Vector2(118.0, 14.0),
		Vector2(118.0, 36.0),
		gold_light,
		1.0
	)

	draw_line(
		Vector2(236.0, 14.0),
		Vector2(236.0, 36.0),
		gold_light,
		1.0
	)


func draw_turn_inset() -> void:
	var banner_shadow: StyleBoxFlat = StyleBoxFlat.new()
	banner_shadow.bg_color = Color(0.0, 0.0, 0.0, 0.36)
	banner_shadow.set_corner_radius_all(9)

	draw_style_box(
		banner_shadow,
		Rect2(17.0, 49.0, PANEL_SIZE.x - 34.0, 29.0)
	)

	var banner: StyleBoxFlat = StyleBoxFlat.new()
	banner.bg_color = parchment_light
	banner.border_color = cranberry
	banner.set_border_width_all(2)
	banner.set_corner_radius_all(9)

	draw_style_box(
		banner,
		Rect2(14.0, 45.0, PANEL_SIZE.x - 28.0, 29.0)
	)

	draw_line(
		Vector2(25.0, 49.0),
		Vector2(PANEL_SIZE.x - 25.0, 49.0),
		Color(
			gold_light.r,
			gold_light.g,
			gold_light.b,
			0.85
		),
		1.0
	)


func draw_decorative_rivets() -> void:
	var rivet_positions: Array[Vector2] = [
		Vector2(9.0, 9.0),
		Vector2(PANEL_SIZE.x - 9.0, 9.0),
		Vector2(9.0, PANEL_SIZE.y - 9.0),
		Vector2(
			PANEL_SIZE.x - 9.0,
			PANEL_SIZE.y - 9.0
		)
	]

	for rivet_position: Vector2 in rivet_positions:
		draw_circle(
			rivet_position,
			3.0,
			gold_dark
		)

		draw_circle(
			rivet_position - Vector2(0.6, 0.6),
			1.4,
			gold_light
		)


func draw_top_row() -> void:
	draw_string(
		ThemeDB.fallback_font,
		Vector2(20.0, 30.0),
		player_name,
		HORIZONTAL_ALIGNMENT_LEFT,
		92.0,
		16,
		text_dark
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(121.0, 30.0),
		wild_text,
		HORIZONTAL_ALIGNMENT_CENTER,
		112.0,
		17,
		cranberry
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(242.0, 30.0),
		round_text,
		HORIZONTAL_ALIGNMENT_RIGHT,
		88.0,
		14,
		text_dark
	)


func draw_turn_banner() -> void:
	var turn_color: Color = cranberry_dark

	if turn_text.contains("Grace"):
		turn_color = walnut
	elif (
		turn_text.contains("Complete")
		or turn_text.contains("Game Over")
	):
		turn_color = gold_dark

	draw_string(
		ThemeDB.fallback_font,
		Vector2(22.0, 67.0),
		turn_text.to_upper(),
		HORIZONTAL_ALIGNMENT_CENTER,
		306.0,
		20,
		turn_color
	)