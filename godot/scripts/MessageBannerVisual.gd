class_name MessageBannerVisual
extends Node2D

const MESSAGE_PANEL_PATH := "res://assets/ui/message_panel.png"

const BANNER_SIZE := Vector2(320, 52)

var parchment := Color("#F1DCB9")
var parchment_light := Color("#FFF1D3")
var parchment_dark := Color("#C7A36E")

var cranberry := Color("#741E2D")
var cranberry_dark := Color("#3A0D16")

var walnut := Color("#3A1D11")
var walnut_light := Color("#63402A")
var walnut_dark := Color("#1D0D08")

var gold := Color("#D7A63C")
var gold_light := Color("#F3D27A")
var gold_dark := Color("#875915")

var text_color := Color("#4B1720")

var message := "Grace deals one card at a time."

var panel_texture: Texture2D
var message_tween: Tween


func _ready():
	if ResourceLoader.exists(MESSAGE_PANEL_PATH):
		panel_texture = load(MESSAGE_PANEL_PATH)

	queue_redraw()


func set_message(new_message: String):
	if message == new_message:
		return

	message = new_message
	queue_redraw()
	animate_message_change()


func animate_message_change():
	if message_tween != null and message_tween.is_valid():
		message_tween.kill()

	scale = Vector2(0.985, 0.985)
	modulate = Color(1, 1, 1, 0.74)

	message_tween = create_tween()
	message_tween.set_trans(Tween.TRANS_BACK)
	message_tween.set_ease(Tween.EASE_OUT)

	message_tween.tween_property(
		self,
		"scale",
		Vector2(1.012, 1.012),
		0.12
	)

	message_tween.parallel().tween_property(
		self,
		"modulate",
		Color.WHITE,
		0.12
	)

	message_tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.10
	)


func _draw():
	if panel_texture != null:
		draw_texture_rect(
			panel_texture,
			Rect2(Vector2.ZERO, BANNER_SIZE),
			false
		)
	else:
		draw_production_panel()

	draw_message_text()


func draw_message_text():
	var font_size := 15

	if message.length() > 54:
		font_size = 13
	elif message.length() > 40:
		font_size = 14

	draw_multiline_string(
		ThemeDB.fallback_font,
		Vector2(18, 20),
		message,
		HORIZONTAL_ALIGNMENT_CENTER,
		284,
		font_size,
		-1,
		text_color
	)


func draw_production_panel():
	draw_shadows()
	draw_wood_frame()
	draw_gold_trim()
	draw_parchment_center()
	draw_scroll_details()


func draw_shadows():
	var shadow := StyleBoxFlat.new()
	shadow.bg_color = Color(0, 0, 0, 0.34)
	shadow.set_corner_radius_all(15)

	draw_style_box(
		shadow,
		Rect2(5, 7, BANNER_SIZE.x, BANNER_SIZE.y)
	)

	var close_shadow := StyleBoxFlat.new()
	close_shadow.bg_color = Color(0, 0, 0, 0.16)
	close_shadow.set_corner_radius_all(14)

	draw_style_box(
		close_shadow,
		Rect2(2, 4, BANNER_SIZE.x, BANNER_SIZE.y)
	)


func draw_wood_frame():
	var frame := StyleBoxFlat.new()
	frame.bg_color = walnut
	frame.border_color = walnut_dark
	frame.set_border_width_all(3)
	frame.set_corner_radius_all(15)

	draw_style_box(
		frame,
		Rect2(Vector2.ZERO, BANNER_SIZE)
	)

	draw_rect(
		Rect2(7, 5, BANNER_SIZE.x - 14, 7),
		Color(
			walnut_light.r,
			walnut_light.g,
			walnut_light.b,
			0.60
		)
	)


func draw_gold_trim():
	var trim := StyleBoxFlat.new()
	trim.bg_color = Color(0, 0, 0, 0)
	trim.border_color = gold_dark
	trim.set_border_width_all(3)
	trim.set_corner_radius_all(12)

	draw_style_box(
		trim,
		Rect2(5, 5, BANNER_SIZE.x - 10, BANNER_SIZE.y - 10)
	)

	var highlight := StyleBoxFlat.new()
	highlight.bg_color = Color(0, 0, 0, 0)
	highlight.border_color = gold_light
	highlight.set_border_width_all(1)
	highlight.set_corner_radius_all(10)

	draw_style_box(
		highlight,
		Rect2(8, 8, BANNER_SIZE.x - 16, BANNER_SIZE.y - 16)
	)


func draw_parchment_center():
	var inset := StyleBoxFlat.new()
	inset.bg_color = parchment
	inset.border_color = parchment_dark
	inset.set_border_width_all(2)
	inset.set_corner_radius_all(8)

	draw_style_box(
		inset,
		Rect2(13, 10, BANNER_SIZE.x - 26, BANNER_SIZE.y - 20)
	)

	draw_rect(
		Rect2(17, 13, BANNER_SIZE.x - 34, 4),
		Color(
			parchment_light.r,
			parchment_light.g,
			parchment_light.b,
			0.72
		)
	)


func draw_scroll_details():
	draw_circle(
		Vector2(12, BANNER_SIZE.y / 2),
		6,
		gold_dark
	)

	draw_circle(
		Vector2(BANNER_SIZE.x - 12, BANNER_SIZE.y / 2),
		6,
		gold_dark
	)

	draw_circle(
		Vector2(12, BANNER_SIZE.y / 2),
		3,
		gold_light
	)

	draw_circle(
		Vector2(BANNER_SIZE.x - 12, BANNER_SIZE.y / 2),
		3,
		gold_light
	)

	draw_line(
		Vector2(22, BANNER_SIZE.y - 14),
		Vector2(BANNER_SIZE.x - 22, BANNER_SIZE.y - 14),
		Color(
			cranberry.r,
			cranberry.g,
			cranberry.b,
			0.50
		),
		1
	)