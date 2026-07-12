class_name ActionButtonVisual
extends Button

const NORMAL_TEXTURE_PATH := "res://assets/ui/button_normal.png"
const HOVER_TEXTURE_PATH := "res://assets/ui/button_hover.png"
const PRESSED_TEXTURE_PATH := "res://assets/ui/button_pressed.png"
const DISABLED_TEXTURE_PATH := "res://assets/ui/button_disabled.png"

var cranberry := Color("#7A1E2C")
var cranberry_light := Color("#963047")
var cranberry_dark := Color("#481019")
var cream := Color("#FFF4DF")
var gold := Color("#D8A441")
var gold_light := Color("#F0CB74")

var motion_tween: Tween

func _ready():
	custom_minimum_size = Vector2(100, 52)
	flat = false
	focus_mode = Control.FOCUS_NONE

	add_theme_font_size_override("font_size", 18)

	add_theme_color_override("font_color", cream)
	add_theme_color_override("font_hover_color", Color.WHITE)
	add_theme_color_override("font_pressed_color", gold_light)
	add_theme_color_override(
		"font_disabled_color",
		Color("#D0BFB0")
	)

	apply_button_styles()

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

	call_deferred("_configure_pivot")

func set_available(value: bool):
	disabled = not value

	if disabled:
		animate_scale(Vector2.ONE, 0.10)
		modulate = Color(1, 1, 1, 0.72)
	else:
		modulate = Color.WHITE

func apply_button_styles():
	if ResourceLoader.exists(NORMAL_TEXTURE_PATH):
		add_theme_stylebox_override(
			"normal",
			make_texture_style(NORMAL_TEXTURE_PATH)
		)
	else:
		add_theme_stylebox_override(
			"normal",
			make_flat_style(cranberry, gold, 3, 5)
		)

	if ResourceLoader.exists(HOVER_TEXTURE_PATH):
		add_theme_stylebox_override(
			"hover",
			make_texture_style(HOVER_TEXTURE_PATH)
		)
	else:
		add_theme_stylebox_override(
			"hover",
			make_flat_style(
				cranberry_light,
				gold_light,
				3,
				7
			)
		)

	if ResourceLoader.exists(PRESSED_TEXTURE_PATH):
		add_theme_stylebox_override(
			"pressed",
			make_texture_style(PRESSED_TEXTURE_PATH)
		)
	else:
		add_theme_stylebox_override(
			"pressed",
			make_flat_style(cranberry_dark, gold, 2, 2)
		)

	if ResourceLoader.exists(DISABLED_TEXTURE_PATH):
		add_theme_stylebox_override(
			"disabled",
			make_texture_style(DISABLED_TEXTURE_PATH)
		)
	else:
		add_theme_stylebox_override(
			"disabled",
			make_flat_style(
				Color("#76665F"),
				Color("#9E8E82"),
				2,
				2
			)
		)

func make_texture_style(texture_path: String) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	var texture: Texture2D = load(texture_path)

	style.texture = texture

	style.texture_margin_left = 18.0
	style.texture_margin_right = 18.0
	style.texture_margin_top = 12.0
	style.texture_margin_bottom = 12.0

	style.content_margin_left = 14.0
	style.content_margin_right = 14.0
	style.content_margin_top = 9.0
	style.content_margin_bottom = 9.0

	return style

func make_flat_style(
	bg_color: Color,
	border_color: Color,
	border_width: int,
	shadow_size: int
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(13)

	style.shadow_color = Color(0, 0, 0, 0.3)
	style.shadow_size = shadow_size
	style.shadow_offset = Vector2(2, 4)

	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 9
	style.content_margin_bottom = 9

	return style

func _configure_pivot():
	pivot_offset = size / 2.0

func animate_scale(
	target_scale: Vector2,
	duration: float
):
	if motion_tween != null and motion_tween.is_valid():
		motion_tween.kill()

	motion_tween = create_tween()
	motion_tween.set_trans(Tween.TRANS_BACK)
	motion_tween.set_ease(Tween.EASE_OUT)

	motion_tween.tween_property(
		self,
		"scale",
		target_scale,
		duration
	)

func _on_mouse_entered():
	if disabled:
		return

	animate_scale(Vector2(1.04, 1.04), 0.12)

func _on_mouse_exited():
	animate_scale(Vector2.ONE, 0.12)

func _on_button_down():
	if disabled:
		return

	animate_scale(Vector2(0.96, 0.96), 0.08)

func _on_button_up():
	if disabled:
		return

	animate_scale(Vector2.ONE, 0.12)