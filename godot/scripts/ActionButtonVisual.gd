class_name ActionButtonVisual
extends Button

const NORMAL_TEXTURE_PATH := "res://assets/ui/button_normal.png"
const HOVER_TEXTURE_PATH := "res://assets/ui/button_hover.png"
const PRESSED_TEXTURE_PATH := "res://assets/ui/button_pressed.png"
const DISABLED_TEXTURE_PATH := "res://assets/ui/button_disabled.png"

var cranberry := Color("#741E2D")
var cranberry_light := Color("#98384D")
var cranberry_dark := Color("#3A0D16")

var cream := Color("#FFF1D8")

var gold := Color("#D7A63C")
var gold_light := Color("#F4D47B")
var gold_dark := Color("#875915")

var walnut := Color("#32180E")
var disabled_fill := Color("#685853")
var disabled_border := Color("#9C8878")

var motion_tween: Tween


func _ready():
	custom_minimum_size = Vector2(112, 54)
	focus_mode = Control.FOCUS_NONE
	flat = false

	add_theme_font_size_override("font_size", 18)
	add_theme_constant_override("outline_size", 2)

	add_theme_color_override("font_color", cream)
	add_theme_color_override("font_hover_color", Color.WHITE)
	add_theme_color_override("font_pressed_color", gold_light)
	add_theme_color_override("font_outline_color", cranberry_dark)

	add_theme_color_override(
		"font_disabled_color",
		Color("#D6C5B6")
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
		modulate = Color(0.78, 0.78, 0.78, 0.86)
	else:
		modulate = Color.WHITE


func apply_button_styles():
	add_theme_stylebox_override(
		"normal",
		load_or_create_style(
			NORMAL_TEXTURE_PATH,
			cranberry,
			gold,
			4,
			Vector2(2, 5)
		)
	)

	add_theme_stylebox_override(
		"hover",
		load_or_create_style(
			HOVER_TEXTURE_PATH,
			cranberry_light,
			gold_light,
			5,
			Vector2(2, 6)
		)
	)

	add_theme_stylebox_override(
		"pressed",
		load_or_create_style(
			PRESSED_TEXTURE_PATH,
			cranberry_dark,
			gold_dark,
			2,
			Vector2(1, 2)
		)
	)

	add_theme_stylebox_override(
		"disabled",
		load_or_create_style(
			DISABLED_TEXTURE_PATH,
			disabled_fill,
			disabled_border,
			2,
			Vector2(1, 2)
		)
	)


func load_or_create_style(
	texture_path: String,
	bg_color: Color,
	border_color: Color,
	shadow_size: int,
	shadow_offset: Vector2
) -> StyleBox:
	if ResourceLoader.exists(texture_path):
		return make_texture_style(texture_path)

	return make_production_flat_style(
		bg_color,
		border_color,
		shadow_size,
		shadow_offset
	)


func make_texture_style(texture_path: String) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	var texture: Texture2D = load(texture_path)

	style.texture = texture

	style.texture_margin_left = 20.0
	style.texture_margin_right = 20.0
	style.texture_margin_top = 14.0
	style.texture_margin_bottom = 14.0

	style.content_margin_left = 16.0
	style.content_margin_right = 16.0
	style.content_margin_top = 10.0
	style.content_margin_bottom = 10.0

	return style


func make_production_flat_style(
	bg_color: Color,
	border_color: Color,
	shadow_size: int,
	shadow_offset: Vector2
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = bg_color
	style.border_color = border_color

	style.border_width_left = 4
	style.border_width_right = 4
	style.border_width_top = 3
	style.border_width_bottom = 5

	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_left = 14
	style.corner_radius_bottom_right = 14

	style.shadow_color = Color(0, 0, 0, 0.42)
	style.shadow_size = shadow_size
	style.shadow_offset = shadow_offset

	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 10
	style.content_margin_bottom = 12

	style.anti_aliasing = true

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

	animate_scale(
		Vector2(1.035, 1.035),
		0.12
	)


func _on_mouse_exited():
	animate_scale(
		Vector2.ONE,
		0.12
	)


func _on_button_down():
	if disabled:
		return

	animate_scale(
		Vector2(0.955, 0.955),
		0.07
	)


func _on_button_up():
	if disabled:
		return

	animate_scale(
		Vector2.ONE,
		0.11
	)