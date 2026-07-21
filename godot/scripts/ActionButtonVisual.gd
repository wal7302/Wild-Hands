class_name ActionButtonVisual
extends Button

const NORMAL_TEXTURE_PATH := "res://assets/ui/button_normal.png"
const HOVER_TEXTURE_PATH := "res://assets/ui/button_hover.png"
const PRESSED_TEXTURE_PATH := "res://assets/ui/button_pressed.png"
const DISABLED_TEXTURE_PATH := "res://assets/ui/button_disabled.png"

const BUTTON_SIZE := Vector2(112.0, 54.0)

var cranberry := Color("#741E2D")
var cranberry_light := Color("#9E3C51")
var cranberry_dark := Color("#360A13")
var cranberry_disabled := Color("#4C252B")

var cream := Color("#FFF1D8")
var cream_disabled := Color("#C9B39F")

var gold := Color("#D7A63C")
var gold_light := Color("#F5D77E")
var gold_dark := Color("#825411")
var gold_disabled := Color("#8C7047")

var walnut := Color("#2A130B")
var walnut_light := Color("#513020")
var walnut_dark := Color("#160904")

var motion_tween: Tween


func _ready() -> void:
	custom_minimum_size = BUTTON_SIZE
	size = BUTTON_SIZE

	focus_mode = Control.FOCUS_NONE
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	flat = false
	clip_contents = false

	add_theme_font_size_override(
		"font_size",
		18
	)

	add_theme_constant_override(
		"outline_size",
		2
	)

	add_theme_constant_override(
		"shadow_offset_x",
		1
	)

	add_theme_constant_override(
		"shadow_offset_y",
		2
	)

	add_theme_color_override(
		"font_color",
		cream
	)

	add_theme_color_override(
		"font_hover_color",
		Color.WHITE
	)

	add_theme_color_override(
		"font_pressed_color",
		gold_light
	)

	add_theme_color_override(
		"font_focus_color",
		cream
	)

	add_theme_color_override(
		"font_disabled_color",
		cream_disabled
	)

	add_theme_color_override(
		"font_outline_color",
		walnut_dark
	)

	add_theme_color_override(
		"font_shadow_color",
		Color(0.0, 0.0, 0.0, 0.65)
	)

	apply_button_styles()

	mouse_entered.connect(
		_on_mouse_entered
	)

	mouse_exited.connect(
		_on_mouse_exited
	)

	button_down.connect(
		_on_button_down
	)

	button_up.connect(
		_on_button_up
	)

	resized.connect(
		_configure_pivot
	)

	call_deferred(
		"_configure_pivot"
	)


func set_available(value: bool) -> void:
	disabled = not value

	if disabled:
		mouse_default_cursor_shape = Control.CURSOR_ARROW

		animate_button(
			Vector2.ONE,
			Vector2.ZERO,
			0.10
		)

		modulate = Color(
			0.88,
			0.84,
			0.80,
			0.92
		)
	else:
		mouse_default_cursor_shape = (
			Control.CURSOR_POINTING_HAND
		)

		modulate = Color.WHITE


func apply_button_styles() -> void:
	add_theme_stylebox_override(
		"normal",
		load_or_create_style(
			NORMAL_TEXTURE_PATH,
			cranberry,
			gold,
			4,
			5,
			Vector2(2.0, 5.0)
		)
	)

	add_theme_stylebox_override(
		"hover",
		load_or_create_style(
			HOVER_TEXTURE_PATH,
			cranberry_light,
			gold_light,
			4,
			7,
			Vector2(2.0, 6.0)
		)
	)

	add_theme_stylebox_override(
		"pressed",
		load_or_create_style(
			PRESSED_TEXTURE_PATH,
			cranberry_dark,
			gold_dark,
			3,
			2,
			Vector2(1.0, 2.0)
		)
	)

	add_theme_stylebox_override(
		"disabled",
		load_or_create_style(
			DISABLED_TEXTURE_PATH,
			cranberry_disabled,
			gold_disabled,
			3,
			3,
			Vector2(1.0, 3.0)
		)
	)

	add_theme_stylebox_override(
		"focus",
		StyleBoxEmpty.new()
	)


func load_or_create_style(
	texture_path: String,
	bg_color: Color,
	border_color: Color,
	border_width: int,
	shadow_size: int,
	shadow_offset: Vector2
) -> StyleBox:
	if ResourceLoader.exists(texture_path):
		return make_texture_style(
			texture_path
		)

	return make_carved_style(
		bg_color,
		border_color,
		border_width,
		shadow_size,
		shadow_offset
	)


func make_texture_style(
	texture_path: String
) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	var texture: Texture2D = load(texture_path)

	style.texture = texture

	style.texture_margin_left = 22.0
	style.texture_margin_right = 22.0
	style.texture_margin_top = 16.0
	style.texture_margin_bottom = 16.0

	style.content_margin_left = 16.0
	style.content_margin_right = 16.0
	style.content_margin_top = 9.0
	style.content_margin_bottom = 12.0

	return style


func make_carved_style(
	bg_color: Color,
	border_color: Color,
	border_width: int,
	shadow_size: int,
	shadow_offset: Vector2
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = bg_color
	style.border_color = border_color

	style.border_width_left = border_width
	style.border_width_right = border_width
	style.border_width_top = border_width
	style.border_width_bottom = border_width + 1

	style.corner_radius_top_left = 15
	style.corner_radius_top_right = 15
	style.corner_radius_bottom_left = 15
	style.corner_radius_bottom_right = 15

	style.shadow_color = Color(
		0.03,
		0.01,
		0.0,
		0.72
	)

	style.shadow_size = shadow_size
	style.shadow_offset = shadow_offset

	style.content_margin_left = 15.0
	style.content_margin_right = 15.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 11.0

	style.anti_aliasing = true
	style.anti_aliasing_size = 1.5

	return style


func _configure_pivot() -> void:
	pivot_offset = size / 2.0


func animate_button(
	target_scale: Vector2,
	target_position_offset: Vector2,
	duration: float
) -> void:
	if (
		motion_tween != null
		and motion_tween.is_valid()
	):
		motion_tween.kill()

	motion_tween = create_tween()
	motion_tween.set_parallel(true)

	motion_tween.set_trans(
		Tween.TRANS_BACK
	)

	motion_tween.set_ease(
		Tween.EASE_OUT
	)

	motion_tween.tween_property(
		self,
		"scale",
		target_scale,
		duration
	)

	motion_tween.tween_property(
		self,
		"position",
		position + target_position_offset,
		duration
	)


func animate_scale(
	target_scale: Vector2,
	duration: float
) -> void:
	if (
		motion_tween != null
		and motion_tween.is_valid()
	):
		motion_tween.kill()

	motion_tween = create_tween()

	motion_tween.set_trans(
		Tween.TRANS_BACK
	)

	motion_tween.set_ease(
		Tween.EASE_OUT
	)

	motion_tween.tween_property(
		self,
		"scale",
		target_scale,
		duration
	)


func _on_mouse_entered() -> void:
	if disabled:
		return

	animate_scale(
		Vector2(1.045, 1.045),
		0.13
	)


func _on_mouse_exited() -> void:
	animate_scale(
		Vector2.ONE,
		0.12
	)


func _on_button_down() -> void:
	if disabled:
		return

	animate_scale(
		Vector2(0.94, 0.94),
		0.065
	)


func _on_button_up() -> void:
	if disabled:
		return

	if get_global_rect().has_point(
		get_global_mouse_position()
	):
		animate_scale(
			Vector2(1.045, 1.045),
			0.10
		)
	else:
		animate_scale(
			Vector2.ONE,
			0.10
		)