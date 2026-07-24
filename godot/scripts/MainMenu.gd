extends Control

signal play_requested

const ActionButtonScene := preload(
	"res://scenes/ActionButton.tscn"
)

var cranberry := Color("#7A1E2C")
var cranberry_dark := Color("#481019")
var cream := Color("#F4E7D3")
var parchment := Color("#FFF4DF")
var walnut := Color("#4B2919")
var gold := Color("#D8A441")
var text_dark := Color("#342016")

func _ready():
	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	build_background()
	build_header()
	build_menu_panel()
	build_footer()

func build_background():
	var background := ColorRect.new()
	background.color = Color("#E8D0AF")
	background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var upper_glow := ColorRect.new()
	upper_glow.color = Color("#F8EAD5")
	upper_glow.position = Vector2(16, 120)
	upper_glow.size = Vector2(358, 570)
	upper_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(upper_glow)

	var floor_panel := ColorRect.new()
	floor_panel.color = walnut
	floor_panel.position = Vector2(0, 680)
	floor_panel.size = Vector2(390, 164)
	floor_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(floor_panel)

	var vignette_left := ColorRect.new()
	vignette_left.color = Color(0.12, 0.04, 0.02, 0.18)
	vignette_left.position = Vector2.ZERO
	vignette_left.size = Vector2(18, 844)
	vignette_left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(vignette_left)

	var vignette_right := ColorRect.new()
	vignette_right.color = Color(0.12, 0.04, 0.02, 0.18)
	vignette_right.position = Vector2(372, 0)
	vignette_right.size = Vector2(18, 844)
	vignette_right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(vignette_right)

func build_header():
	var title := Label.new()
	title.text = "Wild Hands"
	title.position = Vector2(40, 88)
	title.size = Vector2(310, 62)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 46)
	title.add_theme_color_override(
		"font_color",
		cranberry
	)
	add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Friday Night at Grace's"
	subtitle.position = Vector2(45, 148)
	subtitle.size = Vector2(300, 34)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 19)
	subtitle.add_theme_color_override(
		"font_color",
		text_dark
	)
	add_child(subtitle)

	var divider := ColorRect.new()
	divider.color = gold
	divider.position = Vector2(85, 197)
	divider.size = Vector2(220, 3)
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(divider)

func build_menu_panel():
	var shadow := Panel.new()
	shadow.position = Vector2(49, 260)
	shadow.size = Vector2(300, 330)

	var shadow_style := StyleBoxFlat.new()
	shadow_style.bg_color = Color(0, 0, 0, 0.24)
	shadow_style.set_corner_radius_all(18)
	shadow.add_theme_stylebox_override(
		"panel",
		shadow_style
	)
	add_child(shadow)

	var panel := Panel.new()
	panel.position = Vector2(43, 252)
	panel.size = Vector2(300, 330)

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = parchment
	panel_style.border_color = cranberry_dark
	panel_style.set_border_width_all(3)
	panel_style.set_corner_radius_all(18)
	panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)
	add_child(panel)

	var welcome := Label.new()
	welcome.text = "Welcome to Grace's table"
	welcome.position = Vector2(20, 31)
	welcome.size = Vector2(260, 32)
	welcome.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	welcome.add_theme_font_size_override("font_size", 20)
	welcome.add_theme_color_override(
		"font_color",
		cranberry_dark
	)
	panel.add_child(welcome)

	var message := Label.new()
	message.text = "Pull up a chair, honey."
	message.position = Vector2(20, 70)
	message.size = Vector2(260, 28)
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.add_theme_font_size_override("font_size", 16)
	message.add_theme_color_override(
		"font_color",
		text_dark
	)
	panel.add_child(message)

	var play_button := create_menu_button(
		"Play",
		Vector2(50, 125),
		Vector2(200, 58)
	)
	play_button.pressed.connect(
		func():
			play_requested.emit()
	)
	panel.add_child(play_button)

	var rules_button := create_menu_button(
		"How to Play",
		Vector2(50, 200),
		Vector2(200, 52)
	)
	rules_button.disabled = true
	rules_button.tooltip_text = (
		"Rules screen will be added in a later sprint."
	)
	panel.add_child(rules_button)

func build_footer():
	var footer := Label.new()
	footer.text = "A cozy card game with a wild side"
	footer.position = Vector2(40, 735)
	footer.size = Vector2(310, 30)
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.add_theme_font_size_override("font_size", 15)
	footer.add_theme_color_override(
		"font_color",
		cream
	)
	add_child(footer)

func create_menu_button(
	button_text: String,
	button_position: Vector2,
	button_size: Vector2
) -> Button:
	var button: Button = ActionButtonScene.instantiate()

	button.text = button_text
	button.position = button_position
	button.size = button_size
	button.custom_minimum_size = button_size

	return button
