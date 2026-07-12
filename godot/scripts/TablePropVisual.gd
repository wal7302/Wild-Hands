class_name TablePropsVisual
extends Node2D

var cranberry := Color("#7A1E2C")
var cranberry_light := Color("#A63A4E")
var cream := Color("#F4E7D3")
var parchment := Color("#FFF4DF")
var gold := Color("#D8A441")
var walnut_dark := Color("#2B160D")
var glass_color := Color(0.92, 0.96, 1.0, 0.34)
var shadow_color := Color(0, 0, 0, 0.28)

func _ready():
	queue_redraw()

func _draw():
	draw_wine_glass(Vector2(64, 258))
	draw_cookie_plate(Vector2(314, 258))
	draw_reading_glasses(Vector2(55, 463))
	draw_score_pad(Vector2(285, 465))

func draw_wine_glass(origin: Vector2):
	draw_ellipse_shadow(origin + Vector2(0, 24), Vector2(20, 7))

	draw_circle(
		origin,
		18.0,
		glass_color
	)

	draw_circle(
		origin,
		15.0,
		Color(cranberry.r, cranberry.g, cranberry.b, 0.88)
	)

	draw_arc(
		origin,
		18.0,
		0.0,
		TAU,
		32,
		Color(1, 1, 1, 0.65),
		2.0
	)

	draw_line(
		origin + Vector2(0, 18),
		origin + Vector2(0, 38),
		Color(0.92, 0.96, 1.0, 0.65),
		3.0
	)

	draw_line(
		origin + Vector2(-11, 38),
		origin + Vector2(11, 38),
		Color(0.92, 0.96, 1.0, 0.65),
		3.0
	)

	draw_circle(
		origin + Vector2(-6, -7),
		3.0,
		Color(1, 1, 1, 0.28)
	)

func draw_cookie_plate(origin: Vector2):
	draw_ellipse_shadow(origin + Vector2(0, 11), Vector2(30, 10))

	draw_circle(
		origin,
		29.0,
		Color("#EEE2CB")
	)

	draw_arc(
		origin,
		29.0,
		0.0,
		TAU,
		40,
		gold,
		2.0
	)

	draw_cookie(origin + Vector2(-10, -4), 12.0)
	draw_cookie(origin + Vector2(8, -7), 11.0)
	draw_cookie(origin + Vector2(5, 10), 12.0)
	draw_cookie(origin + Vector2(-13, 12), 10.0)

func draw_cookie(origin: Vector2, radius: float):
	draw_circle(
		origin + Vector2(2, 3),
		radius,
		Color(0, 0, 0, 0.18)
	)

	draw_circle(
		origin,
		radius,
		Color("#C98242")
	)

	draw_arc(
		origin,
		radius,
		0.0,
		TAU,
		24,
		Color("#8B4C25"),
		1.5
	)

	var chips := [
		Vector2(-4, -3),
		Vector2(4, -5),
		Vector2(1, 3),
		Vector2(-5, 5)
	]

	for chip: Vector2 in chips:
		draw_circle(
			origin + chip,
			1.8,
			Color("#4A2415")
		)

func draw_reading_glasses(origin: Vector2):
	draw_ellipse_shadow(origin + Vector2(18, 9), Vector2(34, 8))

	var lens_color := Color(0.92, 0.96, 1.0, 0.10)
	var frame_color := Color("#3A2118")

	draw_circle(origin, 13.0, lens_color)
	draw_circle(origin + Vector2(32, 0), 13.0, lens_color)

	draw_arc(
		origin,
		13.0,
		0.0,
		TAU,
		28,
		frame_color,
		3.0
	)

	draw_arc(
		origin + Vector2(32, 0),
		13.0,
		0.0,
		TAU,
		28,
		frame_color,
		3.0
	)

	draw_line(
		origin + Vector2(13, 0),
		origin + Vector2(19, 0),
		frame_color,
		3.0
	)

	draw_line(
		origin + Vector2(-12, -2),
		origin + Vector2(-28, -10),
		frame_color,
		3.0
	)

	draw_line(
		origin + Vector2(44, -2),
		origin + Vector2(60, -10),
		frame_color,
		3.0
	)

func draw_score_pad(origin: Vector2):
	var pad_size := Vector2(64, 82)

	var shadow_style := StyleBoxFlat.new()
	shadow_style.bg_color = shadow_color
	shadow_style.set_corner_radius_all(5)

	draw_style_box(
		shadow_style,
		Rect2(origin + Vector2(5, 6), pad_size)
	)

	var pad_style := StyleBoxFlat.new()
	pad_style.bg_color = parchment
	pad_style.border_color = cranberry
	pad_style.set_border_width_all(2)
	pad_style.set_corner_radius_all(5)

	draw_style_box(
		pad_style,
		Rect2(origin, pad_size)
	)

	draw_rect(
		Rect2(origin + Vector2(0, 0), Vector2(64, 15)),
		cranberry,
		true
	)

	draw_string(
		ThemeDB.fallback_font,
		origin + Vector2(8, 12),
		"SCORE",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		10,
		gold
	)

	for i: int in range(4):
		var line_y: float = origin.y + 27.0 + float(i * 12)

		draw_line(
			Vector2(origin.x + 9, line_y),
			Vector2(origin.x + 54, line_y),
			Color(0.40, 0.22, 0.16, 0.34),
			1.0
		)

	draw_string(
		ThemeDB.fallback_font,
		origin + Vector2(11, 39),
		"12",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		12,
		walnut_dark
	)

	draw_string(
		ThemeDB.fallback_font,
		origin + Vector2(39, 51),
		"8",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		12,
		walnut_dark
	)

	draw_pencil(origin + Vector2(57, 15))

func draw_pencil(origin: Vector2):
	draw_line(
		origin + Vector2(3, 4),
		origin + Vector2(-8, 58),
		Color(0, 0, 0, 0.22),
		6.0
	)

	draw_line(
		origin,
		origin + Vector2(-11, 54),
		gold,
		6.0
	)

	draw_line(
		origin + Vector2(-11, 54),
		origin + Vector2(-14, 62),
		cranberry_light,
		6.0
	)

	draw_circle(
		origin + Vector2(-14, 62),
		2.0,
		Color("#3A2118")
	)

func draw_ellipse_shadow(origin: Vector2, ellipse_size: Vector2):
	for i: int in range(5, 0, -1):
		var radius_x: float = ellipse_size.x * float(i) / 5.0
		var radius_y: float = ellipse_size.y * float(i) / 5.0

		draw_set_transform(
			origin,
			0.0,
			Vector2(1.0, radius_y / radius_x)
		)

		draw_circle(
			Vector2.ZERO,
			radius_x,
			Color(0, 0, 0, 0.016 * float(i))
		)

	draw_set_transform(
		Vector2.ZERO,
		0.0,
		Vector2.ONE
	)