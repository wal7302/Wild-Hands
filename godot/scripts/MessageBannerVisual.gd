class_name MessageBannerVisual
extends Node2D

const MESSAGE_PANEL_PATH := "res://assets/ui/message_panel.png"

var banner_size := Vector2(320, 38)

var panel_color := Color("#FFF4DF")
var border_color := Color("#7A1E2C")
var gold := Color("#D8A441")
var text_color := Color("#5D1825")

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
	modulate = Color(1, 1, 1, 0.76)

	message_tween = create_tween()
	message_tween.set_trans(Tween.TRANS_BACK)
	message_tween.set_ease(Tween.EASE_OUT)

	message_tween.tween_property(
		self,
		"scale",
		Vector2(1.015, 1.015),
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
			Rect2(Vector2.ZERO, banner_size),
			false
		)
	else:
		draw_fallback_panel()

	draw_string(
		ThemeDB.fallback_font,
		Vector2(14, 25),
		message,
		HORIZONTAL_ALIGNMENT_CENTER,
		292,
		15,
		text_color
	)

func draw_fallback_panel():
	var shadow_style := StyleBoxFlat.new()
	shadow_style.bg_color = Color(0, 0, 0, 0.25)
	shadow_style.set_corner_radius_all(11)

	draw_style_box(
		shadow_style,
		Rect2(Vector2(4, 5), banner_size)
	)

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = panel_color
	panel_style.border_color = border_color
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(11)

	draw_style_box(
		panel_style,
		Rect2(Vector2.ZERO, banner_size)
	)

	draw_line(
		Vector2(20, 32),
		Vector2(300, 32),
		gold,
		1
	)