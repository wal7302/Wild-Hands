extends Control

signal back_requested
signal start_game_requested(settings)

const ActionButtonScene := preload(
	"res://scenes/ActionButton.tscn"
)

var cranberry := Color("#7A1E2C")
var cranberry_dark := Color("#481019")
var cream := Color("#F4E7D3")
var parchment := Color("#FFF4DF")
var parchment_light := Color("#FFFAEF")
var walnut := Color("#4B2919")
var gold := Color("#D8A441")
var text_dark := Color("#342016")

var selected_game_type := "full"
var selected_play_mode := "solo"

var game_type_buttons: Dictionary = {}
var selection_status: Label

func _ready():
	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	build_background()
	build_header()
	build_play_mode_section()
	build_game_type_section()
	build_status()
	build_navigation()

	update_game_type_buttons()

func build_background():
	var background := ColorRect.new()
	background.color = Color("#E8D0AF")
	background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var room_panel := ColorRect.new()
	room_panel.color = Color("#F8EAD5")
	room_panel.position = Vector2(12, 95)
	room_panel.size = Vector2(366, 650)
	room_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(room_panel)

	var floor := ColorRect.new()
	floor.color = walnut
	floor.position = Vector2(0, 745)
	floor.size = Vector2(390, 99)
	floor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(floor)

func build_header():
	var title := Label.new()
	title.text = "Choose Your Game"
	title.position = Vector2(30, 34)
	title.size = Vector2(330, 48)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 31)
	title.add_theme_color_override(
		"font_color",
		cranberry
	)
	add_child(title)

func build_play_mode_section():
	var panel := create_section_panel(
		Vector2(25, 112),
		Vector2(340, 175)
	)
	add_child(panel)

	var heading := create_heading(
		"Who are you playing with?",
		Vector2(15, 13),
		Vector2(310, 28)
	)
	panel.add_child(heading)

	var solo_button := create_setup_button(
		"Solo with Grace",
		Vector2(45, 50),
		Vector2(250, 48)
	)
	solo_button.pressed.connect(
		func():
			selected_play_mode = "solo"
			update_status()
	)
	panel.add_child(solo_button)

	var online_button := create_setup_button(
		"Online Match — Coming Soon",
		Vector2(45, 108),
		Vector2(250, 42)
	)
	online_button.disabled = true
	panel.add_child(online_button)

func build_game_type_section():
	var panel := create_section_panel(
		Vector2(25, 305),
		Vector2(340, 320)
	)
	add_child(panel)

	var heading := create_heading(
		"Game Type",
		Vector2(15, 13),
		Vector2(310, 28)
	)
	panel.add_child(heading)

	create_game_type_button(
		panel,
		"Lightning — 3 Hands",
		"lightning",
		Vector2(40, 52)
	)

	create_game_type_button(
		panel,
		"Half Game — Low",
		"half_low",
		Vector2(40, 111)
	)

	create_game_type_button(
		panel,
		"Half Game — High",
		"half_high",
		Vector2(40, 170)
	)

	create_game_type_button(
		panel,
		"Full Game — 11 Hands",
		"full",
		Vector2(40, 229)
	)

func create_game_type_button(
	parent: Control,
	button_text: String,
	game_type: String,
	button_position: Vector2
):
	var button := Button.new()

	button.text = button_text
	button.position = button_position
	button.size = Vector2(260, 45)
	button.custom_minimum_size = Vector2(260, 45)
	button.toggle_mode = true
	button.focus_mode = Control.FOCUS_NONE

	button.add_theme_font_size_override(
		"font_size",
		16
	)

	button.pressed.connect(
		func():
			select_game_type(game_type)
	)

	parent.add_child(button)
	game_type_buttons[game_type] = button

func select_game_type(game_type: String):
	selected_game_type = game_type
	update_game_type_buttons()
	update_status()

func update_game_type_buttons():
	for game_type: String in game_type_buttons:
		var button: Button = game_type_buttons[game_type]
		var is_selected: bool = (
			game_type == selected_game_type
		)

		button.set_pressed_no_signal(is_selected)

		var style := StyleBoxFlat.new()
		style.set_corner_radius_all(11)
		style.set_border_width_all(
			3 if is_selected else 2
		)

		if is_selected:
			style.bg_color = cranberry
			style.border_color = gold

			button.add_theme_color_override(
				"font_color",
				cream
			)
			button.add_theme_color_override(
				"font_pressed_color",
				cream
			)
		else:
			style.bg_color = parchment_light
			style.border_color = Color("#B98B5B")

			button.add_theme_color_override(
				"font_color",
				text_dark
			)
			button.add_theme_color_override(
				"font_pressed_color",
				text_dark
			)

		button.add_theme_stylebox_override(
			"normal",
			style
		)
		button.add_theme_stylebox_override(
			"pressed",
			style
		)
		button.add_theme_stylebox_override(
			"hover",
			style
		)

func build_status():
	selection_status = Label.new()
	selection_status.position = Vector2(35, 640)
	selection_status.size = Vector2(320, 43)
	selection_status.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	selection_status.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	selection_status.add_theme_font_size_override(
		"font_size",
		15
	)
	selection_status.add_theme_color_override(
		"font_color",
		cranberry_dark
	)
	add_child(selection_status)

	update_status()

func update_status():
	var game_name: String = get_game_type_name(
		selected_game_type
	)

	selection_status.text = (
		"Solo with Grace • " + game_name
	)

func build_navigation():
	var back_button := create_setup_button(
		"Back",
		Vector2(35, 700),
		Vector2(125, 52)
	)
	back_button.pressed.connect(
		func():
			back_requested.emit()
	)
	add_child(back_button)

	var start_button := create_setup_button(
		"Start Game",
		Vector2(205, 700),
		Vector2(150, 52)
	)
	start_button.pressed.connect(start_selected_game)
	add_child(start_button)

func start_selected_game():
	var settings := {
		"play_mode": selected_play_mode,
		"game_type": selected_game_type,
		"game_type_name": get_game_type_name(
			selected_game_type
		)
	}

	start_game_requested.emit(settings)

func get_game_type_name(game_type: String) -> String:
	match game_type:
		"lightning":
			return "Lightning"
		"half_low":
			return "Half Game — Low"
		"half_high":
			return "Half Game — High"
		"full":
			return "Full Game"
		_:
			return "Full Game"

func create_section_panel(
	panel_position: Vector2,
	panel_size: Vector2
) -> Panel:
	var panel := Panel.new()
	panel.position = panel_position
	panel.size = panel_size

	var shadow_style := StyleBoxFlat.new()
	shadow_style.bg_color = parchment
	shadow_style.border_color = cranberry_dark
	shadow_style.set_border_width_all(2)
	shadow_style.set_corner_radius_all(15)
	shadow_style.shadow_color = Color(0, 0, 0, 0.20)
	shadow_style.shadow_size = 5
	shadow_style.shadow_offset = Vector2(3, 4)

	panel.add_theme_stylebox_override(
		"panel",
		shadow_style
	)

	return panel

func create_heading(
	heading_text: String,
	heading_position: Vector2,
	heading_size: Vector2
) -> Label:
	var heading := Label.new()
	heading.text = heading_text
	heading.position = heading_position
	heading.size = heading_size
	heading.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	heading.add_theme_font_size_override(
		"font_size",
		18
	)
	heading.add_theme_color_override(
		"font_color",
		cranberry_dark
	)

	return heading

func create_setup_button(
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