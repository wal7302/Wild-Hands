extends Node2D

const CardScene := preload("res://scenes/Card.tscn")
const DeckScene := preload("res://scenes/Deck.tscn")
const DiscardPileScene := preload(
	"res://scenes/DiscardPile.tscn"
)
const MessageBannerScene := preload(
	"res://scenes/MessageBanner.tscn"
)
const ActionButtonScene := preload(
	"res://scenes/ActionButton.tscn"
)
const PlayerSeatScene := preload(
	"res://scenes/PlayerSeat.tscn"
)
const RoomBackgroundScene := preload(
	"res://scenes/RoomBackground.tscn"
)
const WoodTableScene := preload(
	"res://scenes/WoodTable.tscn"
)
const GameHudScene := preload(
	"res://scenes/GameHud.tscn"
)
const AmbientEffectsScene := preload(
	"res://scenes/AmbientEffects.tscn"
)
const TablePropsScene := preload(
	"res://scenes/TableProps.tscn"
)

var cranberry := Color("#7A1E2C")
var cream := Color("#F4E7D3")
var gold := Color("#D8A441")
var walnut_dark := Color("#2B160D")
var wild_marker: WildMarker
var wild_reveal_sound: AudioStream


const TABLE_WIDTH: float = 390.0

# --------------------------------------------------------------------
# PRODUCTION LAYOUT
# Scaled for the current 390 x 844 mobile viewport
# --------------------------------------------------------------------

const TITLE_Y: float = 5.0
const HUD_Y: float = 113.0

const GRACE_SEAT_POSITION := Vector2(42.0, 168.0)
const GRACE_HAND_Y: float = 228.0

const WILD_MARKER_POSITION := Vector2(195.0, 253.0)

const DECK_POSITION := Vector2(108.0, 318.0)
const DISCARD_POSITION := Vector2(236.0, 318.0)

const PLAYER_SEAT_POSITION := Vector2(17.0, 548.0)
const PLAYER_HAND_Y: float = 558.0
const PLAYER_HAND_LABEL_Y: float = 538.0

const MESSAGE_POSITION := Vector2(24.0, 672.0)

const BUTTON_Y: float = 714.0

var deck_position: Vector2 = DECK_POSITION
var discard_position: Vector2 = DISCARD_POSITION

var hand_position: Vector2 = Vector2(
	TABLE_WIDTH / 2.0,
	PLAYER_HAND_Y
)


var game_hud: Node2D
var deck_visual: Node2D
var message_banner: Node2D

var draw_button: Button
var discard_button: Button
var go_out_button: Button
var deck_tap_button: Button
var discard_tap_button: Button

var game_settings: Dictionary = {}
var game_state := GameState.new()
var card_deck := CardDeck.new()
var player_hand := Hand.new()
var grace_ai := GraceAI.new()
var round_winner_index := -1

var grace_hand_data: Array[Dictionary] = []
var grace_hand_cards: Array[Node2D] = []
var grace_revealed_cards: Array[Node2D] = []
var discard_cards: Array[Node2D] = []
var recycled_draw_cards: Array[Dictionary] = []

var selected_card: Node2D = null
var protected_discard_pickup: Node2D = null

var discard_count := 0
var has_drawn := false
var is_animating := false
var round_over := false
var game_over := false

var deal_rng := RandomNumberGenerator.new()


func _ready():
	deal_rng.randomize()

	read_game_settings()
	initialize_game_state()

	build_environment()
	build_title()
	build_hud()
	build_players()
	build_deck_and_discard()
	build_table_props()
	build_wild_marker()
	build_hand_marker()
	build_message()
	build_buttons()

	deal_opening_hand()


func read_game_settings():
	if has_meta("game_settings"):
		game_settings = get_meta(
			"game_settings"
		).duplicate(true)
	else:
		game_settings = {
			"play_mode": "solo",
			"game_type": "full",
			"game_type_name": "Full Game"
		}


func initialize_game_state():
	var game_type: String = String(
		game_settings.get("game_type", "full")
	)

	var selected_mode: GameConfig.GameMode = (
		GameConfig.mode_from_key(game_type)
	)

	game_state.initialize(selected_mode)


func build_environment():
	var room: Node2D = RoomBackgroundScene.instantiate()
	room.z_index = -100
	add_child(room)

	var table: Node2D = WoodTableScene.instantiate()
	table.z_index = -50
	add_child(table)

	var ambient_effects: Node2D = (
		AmbientEffectsScene.instantiate()
	)

	ambient_effects.z_index = 80
	add_child(ambient_effects)


func build_title() -> void:
	var sign_shadow := Panel.new()
	sign_shadow.position = Vector2(28.0, 12.0)
	sign_shadow.size = Vector2(334.0, 100.0)
	sign_shadow.z_index = 92
	sign_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var shadow_style := StyleBoxFlat.new()
	shadow_style.bg_color = Color(0.02, 0.01, 0.01, 0.78)
	shadow_style.corner_radius_top_left = 24
	shadow_style.corner_radius_top_right = 24
	shadow_style.corner_radius_bottom_left = 14
	shadow_style.corner_radius_bottom_right = 14

	sign_shadow.add_theme_stylebox_override(
		"panel",
		shadow_style
	)

	add_child(sign_shadow)


	var outer_sign := Panel.new()
	outer_sign.position = Vector2(38, 8)
	outer_sign.size = Vector2(314, 84)
	outer_sign.z_index = 93
	outer_sign.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var outer_style := StyleBoxFlat.new()
	outer_style.bg_color = Color("#35120D")
	outer_style.border_color = Color("#A86B20")
	outer_style.set_border_width_all(3)

	outer_style.corner_radius_top_left = 25
	outer_style.corner_radius_top_right = 25
	outer_style.corner_radius_bottom_left = 13
	outer_style.corner_radius_bottom_right = 13

	outer_sign.add_theme_stylebox_override(
		"panel",
		outer_style
	)

	add_child(outer_sign)


	var gold_frame := Panel.new()
	gold_frame.position = Vector2(5,5)
	gold_frame.size = Vector2(304,72)
	gold_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var gold_frame_style := StyleBoxFlat.new()
	gold_frame_style.bg_color = Color("#641923")
	gold_frame_style.border_color = Color("#E0A93E")
	gold_frame_style.set_border_width_all(2)

	gold_frame_style.corner_radius_top_left = 20
	gold_frame_style.corner_radius_top_right = 20
	gold_frame_style.corner_radius_bottom_left = 10
	gold_frame_style.corner_radius_bottom_right = 10

	gold_frame.add_theme_stylebox_override(
		"panel",
		gold_frame_style
	)

	outer_sign.add_child(gold_frame)


	var inner_sign := Panel.new()
	inner_sign.position = Vector2(5,5)
	inner_sign.size = Vector2(294,62)
	inner_sign.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var inner_style := StyleBoxFlat.new()
	inner_style.bg_color = Color("#4B111A")
	inner_style.border_color = Color("#7E421A")
	inner_style.set_border_width_all(1)

	inner_style.corner_radius_top_left = 16
	inner_style.corner_radius_top_right = 16
	inner_style.corner_radius_bottom_left = 8
	inner_style.corner_radius_bottom_right = 8

	inner_sign.add_theme_stylebox_override(
		"panel",
		inner_style
	)

	gold_frame.add_child(inner_sign)


	var ornament := Label.new()
	ornament.text = "✦  ❧  ✦"
	ornament.position = Vector2(90.0, 0.0)
	ornament.size = Vector2(140.0, 18.0)
	ornament.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ornament.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ornament.mouse_filter = Control.MOUSE_FILTER_IGNORE

	ornament.add_theme_font_size_override(
		"font_size",
		11
	)

	ornament.add_theme_color_override(
		"font_color",
		Color("#E9B94E")
	)

	inner_sign.add_child(ornament)


	var title := Label.new()
	title.text = "WILD HANDS"
	title.position = Vector2(0,6)
	title.size = Vector2(294,34)
	title.add_theme_font_size_override("font_size",27)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE


	title.add_theme_color_override(
		"font_color",
		Color("#F3CF78")
	)

	title.add_theme_color_override(
		"font_shadow_color",
		Color("#160503")
	)

	title.add_theme_constant_override(
		"shadow_offset_x",
		2
	)

	title.add_theme_constant_override(
		"shadow_offset_y",
		3
	)

	inner_sign.add_child(title)


	var ribbon_shadow := Panel.new()
	ribbon_shadow.position = Vector2(70,58)
	ribbon_shadow.size = Vector2(170,22)
	ribbon_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var ribbon_shadow_style := StyleBoxFlat.new()
	ribbon_shadow_style.bg_color = Color(
		0.02,
		0.01,
		0.0,
		0.80
	)

	ribbon_shadow_style.corner_radius_top_left = 5
	ribbon_shadow_style.corner_radius_top_right = 5
	ribbon_shadow_style.corner_radius_bottom_left = 8
	ribbon_shadow_style.corner_radius_bottom_right = 8

	ribbon_shadow.add_theme_stylebox_override(
		"panel",
		ribbon_shadow_style
	)

	outer_sign.add_child(ribbon_shadow)


	var ribbon := Panel.new()
	ribbon.position = Vector2(67.0, 69.0)
	ribbon.size = Vector2(208.0, 28.0)
	ribbon.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var ribbon_style := StyleBoxFlat.new()
	ribbon_style.bg_color = Color("#B87A30")
	ribbon_style.border_color = Color("#4A1D0A")
	ribbon_style.set_border_width_all(2)

	ribbon_style.corner_radius_top_left = 4
	ribbon_style.corner_radius_top_right = 4
	ribbon_style.corner_radius_bottom_left = 7
	ribbon_style.corner_radius_bottom_right = 7

	ribbon.add_theme_stylebox_override(
		"panel",
		ribbon_style
	)

	outer_sign.add_child(ribbon)


	var subtitle := Label.new()
	subtitle.text = "FRIDAY NIGHT AT GRACE'S"
	subtitle.position = Vector2.ZERO
	subtitle.size = ribbon.size
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	subtitle.mouse_filter = Control.MOUSE_FILTER_IGNORE

	subtitle.add_theme_font_size_override(
		"font_size",
		12
	)

	subtitle.add_theme_color_override(
		"font_color",
		Color("#241006")
	)

	subtitle.add_theme_color_override(
		"font_shadow_color",
		Color(1.0, 0.82, 0.43, 0.30)
	)

	subtitle.add_theme_constant_override(
		"shadow_offset_y",
		1
	)

	ribbon.add_child(subtitle)


func build_hud() -> void:
	var hud_shadow := Panel.new()
	hud_shadow.position = Vector2(20,96)
	hud_shadow.size = Vector2(350,58)
	hud_shadow.z_index = 93
	hud_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var shadow_style := StyleBoxFlat.new()
	shadow_style.bg_color = Color(
		0.01,
		0.005,
		0.0,
		0.75
	)

	shadow_style.corner_radius_top_left = 11
	shadow_style.corner_radius_top_right = 11
	shadow_style.corner_radius_bottom_left = 11
	shadow_style.corner_radius_bottom_right = 11

	hud_shadow.add_theme_stylebox_override(
		"panel",
		shadow_style
	)

	add_child(hud_shadow)


	var hud_frame := Panel.new()
	hud_frame.position = Vector2(13.0, 113.0)
	hud_frame.size = Vector2(364.0, 72.0)
	hud_frame.z_index = 94
	hud_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var frame_style := StyleBoxFlat.new()
	frame_style.bg_color = Color("#26130B")
	frame_style.border_color = Color("#A66A26")
	frame_style.set_border_width_all(2)

	frame_style.corner_radius_top_left = 10
	frame_style.corner_radius_top_right = 10
	frame_style.corner_radius_bottom_left = 10
	frame_style.corner_radius_bottom_right = 10

	hud_frame.add_theme_stylebox_override(
		"panel",
		frame_style
	)

	add_child(hud_frame)


	var hud_inner := Panel.new()
	hud_inner.position = Vector2(4,4)
	hud_inner.size = Vector2(350,50)
	hud_inner.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var inner_style := StyleBoxFlat.new()
	inner_style.bg_color = Color(
		0.08,
		0.035,
		0.015,
		0.94
	)

	inner_style.border_color = Color("#5B3518")
	inner_style.set_border_width_all(1)

	inner_style.corner_radius_top_left = 7
	inner_style.corner_radius_top_right = 7
	inner_style.corner_radius_bottom_left = 7
	inner_style.corner_radius_bottom_right = 7

	hud_inner.add_theme_stylebox_override(
		"panel",
		inner_style
	)

	hud_frame.add_child(hud_inner)


	var divider_one := ColorRect.new()
	divider_one.position = Vector2(111.0, 9.0)
	divider_one.size = Vector2(1.0, 46.0)
	divider_one.color = Color(
		0.75,
		0.48,
		0.20,
		0.38
	)

	divider_one.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud_inner.add_child(divider_one)


	var divider_two := ColorRect.new()
	divider_two.position = Vector2(245.0, 9.0)
	divider_two.size = Vector2(1.0, 46.0)
	divider_two.color = Color(
		0.75,
		0.48,
		0.20,
		0.38
	)

	divider_two.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud_inner.add_child(divider_two)


	var score_heading := Label.new()
	score_heading.text = "SCORE"
	score_heading.position = Vector2(9.0, 5.0)
	score_heading.size = Vector2(94.0, 20.0)
	score_heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_heading.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	score_heading.mouse_filter = Control.MOUSE_FILTER_IGNORE

	score_heading.add_theme_font_size_override(
		"font_size",
		12
	)

	score_heading.add_theme_color_override(
		"font_color",
		Color("#EBCB81")
	)

	hud_inner.add_child(score_heading)


	var score_value := Label.new()
	score_value.text = str(game_state.player_scores[0])
	score_value.position = Vector2(9.0, 22.0)
	score_value.size = Vector2(94.0, 34.0)
	score_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	score_value.mouse_filter = Control.MOUSE_FILTER_IGNORE

	score_value.add_theme_font_size_override(
		"font_size",
		21
	)

	score_value.add_theme_color_override(
		"font_color",
		cream
	)

	score_value.add_theme_color_override(
		"font_shadow_color",
		Color("#120603")
	)

	score_value.add_theme_constant_override(
		"shadow_offset_y",
		2
	)

	hud_inner.add_child(score_value)


	var wild_value := Label.new()
	wild_value.text = "WILD = " + game_state.wild_label()
	wild_value.position = Vector2(116.0, 7.0)
	wild_value.size = Vector2(125.0, 49.0)
	wild_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wild_value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	wild_value.mouse_filter = Control.MOUSE_FILTER_IGNORE

	wild_value.add_theme_font_size_override(
		"font_size",
		18
	)

	wild_value.add_theme_color_override(
		"font_color",
		Color("#E7B64E")
	)

	wild_value.add_theme_color_override(
		"font_shadow_color",
		Color("#140502")
	)

	wild_value.add_theme_constant_override(
		"shadow_offset_x",
		1
	)

	wild_value.add_theme_constant_override(
		"shadow_offset_y",
		2
	)

	hud_inner.add_child(wild_value)


	var round_heading := Label.new()
	round_heading.text = "ROUND"
	round_heading.position = Vector2(250.0, 5.0)
	round_heading.size = Vector2(97.0, 20.0)
	round_heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	round_heading.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	round_heading.mouse_filter = Control.MOUSE_FILTER_IGNORE

	round_heading.add_theme_font_size_override(
		"font_size",
		12
	)

	round_heading.add_theme_color_override(
		"font_color",
		Color("#EBCB81")
	)

	hud_inner.add_child(round_heading)


	var round_value := Label.new()
	round_value.text = (
		str(game_state.current_round)
		+ " of "
		+ str(game_state.total_rounds)
	)

	round_value.position = Vector2(250.0, 22.0)
	round_value.size = Vector2(97.0, 34.0)
	round_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	round_value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	round_value.mouse_filter = Control.MOUSE_FILTER_IGNORE

	round_value.add_theme_font_size_override(
		"font_size",
		18
	)

	round_value.add_theme_color_override(
		"font_color",
		cream
	)

	round_value.add_theme_color_override(
		"font_shadow_color",
		Color("#120603")
	)

	round_value.add_theme_constant_override(
		"shadow_offset_y",
		2
	)

	hud_inner.add_child(round_value)


	game_hud = GameHudScene.instantiate()
	game_hud.position = Vector2(20.0, 112.0)
	game_hud.z_index = 95
	game_hud.visible = false
	add_child(game_hud)

	refresh_hud("Your Turn")


func build_wild_marker() -> void:
	wild_marker = WildMarker.new()
	wild_marker.position = WILD_MARKER_POSITION
	wild_marker.z_index = 75
	add_child(wild_marker)

	var sound_path := "res://assets/audio/wild_reveal.wav"

	if ResourceLoader.exists(sound_path):
		wild_reveal_sound = load(sound_path)


func refresh_hud(turn_text: String):
	if game_hud == null:
		return

	game_hud.configure(
		game_state.dealer_name(),
		"Wild = " + game_state.wild_label(),
		(
			"Round "
			+ str(game_state.current_round)
			+ " of "
			+ str(game_state.total_rounds)
		),
		turn_text
	)


func build_table_props():
	var table_props: Node2D = TablePropsScene.instantiate()
	table_props.z_index = 1
	add_child(table_props)


func build_players() -> void:
	add_player_seat(
		"Grace",
		"🍷",
		GRACE_SEAT_POSITION
	)

	add_player_seat(
		"You",
		"🃏",
		PLAYER_SEAT_POSITION
	)


func add_player_seat(
	display_name: String,
	accent_icon: String,
	pos: Vector2
):
	var seat: Node2D = PlayerSeatScene.instantiate()

	seat.position = pos
	seat.z_index = 96

	add_child(seat)

	if seat.has_method("configure"):
		seat.configure(
			display_name,
			accent_icon
		)


func build_deck_and_discard() -> void:
	deck_visual = DeckScene.instantiate()
	deck_visual.position = deck_position
	deck_visual.rotation_degrees = -3.0
	deck_visual.z_index = 2
	add_child(deck_visual)

	var deck_label := add_label(
		"DECK",
		Vector2(
			deck_position.x - 2.0,
			deck_position.y + 119.0
		),
		cream,
		13
	)

	deck_label.size = Vector2(82.0, 22.0)
	deck_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	deck_label.add_theme_color_override(
		"font_shadow_color",
		walnut_dark
	)

	deck_label.add_theme_constant_override(
		"shadow_offset_x",
		1
	)

	deck_label.add_theme_constant_override(
		"shadow_offset_y",
		2
	)

	var discard_slot: Node2D = (
		DiscardPileScene.instantiate()
	)

	discard_slot.position = discard_position
	discard_slot.rotation_degrees = 2.0
	discard_slot.z_index = 2
	add_child(discard_slot)

	var discard_label := add_label(
		"DISCARD",
		Vector2(
			discard_position.x - 2.0,
			discard_position.y + 119.0
		),
		cream,
		13
	)

	discard_label.size = Vector2(82.0, 22.0)
	discard_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	discard_label.add_theme_color_override(
		"font_shadow_color",
		walnut_dark
	)

	discard_label.add_theme_constant_override(
		"shadow_offset_x",
		1
	)

	discard_label.add_theme_constant_override(
		"shadow_offset_y",
		2
	)

	build_pile_tap_buttons()


func build_pile_tap_buttons():
	deck_tap_button = create_pile_tap_button(
		deck_position,
		Vector2(78, 116)
	)

	deck_tap_button.pressed.connect(
		draw_card
	)

	discard_tap_button = create_pile_tap_button(
		discard_position,
		Vector2(78, 116)
	)

	discard_tap_button.pressed.connect(
		take_top_discard
	)


func create_pile_tap_button(
	pos: Vector2,
	button_size: Vector2
) -> Button:
	var button := Button.new()

	button.position = pos
	button.size = button_size
	button.flat = true
	button.text = ""
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = (
		Control.CURSOR_POINTING_HAND
	)
	button.z_index = 90

	var transparent_style := StyleBoxFlat.new()
	transparent_style.bg_color = Color(
		0.0,
		0.0,
		0.0,
		0.0
	)

	button.add_theme_stylebox_override(
		"normal",
		transparent_style
	)

	button.add_theme_stylebox_override(
		"hover",
		transparent_style
	)

	button.add_theme_stylebox_override(
		"pressed",
		transparent_style
	)

	button.add_theme_stylebox_override(
		"disabled",
		transparent_style
	)

	add_child(button)
	return button


func build_hand_marker() -> void:
	var marker_panel := Panel.new()
	marker_panel.position = Vector2(
		137.0,
		PLAYER_HAND_LABEL_Y - 2.0
	)
	marker_panel.size = Vector2(116.0, 25.0)
	marker_panel.z_index = 89
	marker_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var marker_style := StyleBoxFlat.new()
	marker_style.bg_color = Color(
		0.10,
		0.04,
		0.02,
		0.82
	)
	marker_style.border_color = Color(
		gold.r,
		gold.g,
		gold.b,
		0.80
	)

	marker_style.set_border_width_all(1)

	marker_style.corner_radius_top_left = 9
	marker_style.corner_radius_top_right = 9
	marker_style.corner_radius_bottom_left = 9
	marker_style.corner_radius_bottom_right = 9

	marker_style.shadow_color = Color(
		0.0,
		0.0,
		0.0,
		0.50
	)
	marker_style.shadow_size = 4
	marker_style.shadow_offset = Vector2(0.0, 2.0)

	marker_panel.add_theme_stylebox_override(
		"panel",
		marker_style
	)

	add_child(marker_panel)

	var marker := Label.new()
	marker.text = "YOUR HAND"
	marker.position = Vector2.ZERO
	marker.size = marker_panel.size
	marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	marker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	marker.add_theme_font_size_override(
		"font_size",
		13
	)

	marker.add_theme_color_override(
		"font_color",
		Color("#F1C76D")
	)

	marker.add_theme_color_override(
		"font_shadow_color",
		Color("#160704")
	)

	marker.add_theme_constant_override(
		"shadow_offset_x",
		1
	)

	marker.add_theme_constant_override(
		"shadow_offset_y",
		2
	)

	marker_panel.add_child(marker)

func build_message() -> void:
	message_banner = MessageBannerScene.instantiate()
	message_banner.position = MESSAGE_POSITION
	message_banner.z_index = 100
	add_child(message_banner)

	set_message("Grace is shuffling the deck.")


func build_buttons() -> void:
	discard_button = ActionButtonScene.instantiate()
	discard_button.text = "Discard"
	discard_button.position = Vector2(
		68.0,
		BUTTON_Y
	)
	discard_button.z_index = 110

	discard_button.pressed.connect(
		discard_selected_card
	)

	add_child(discard_button)

	go_out_button = ActionButtonScene.instantiate()
	go_out_button.text = "Go Out"
	go_out_button.position = Vector2(
		218.0,
		BUTTON_Y
	)
	go_out_button.z_index = 110

	go_out_button.pressed.connect(
		on_primary_button_pressed
	)

	add_child(go_out_button)

	update_action_buttons()


func set_message(new_message: String):
	if message_banner != null:
		message_banner.set_message(new_message)


func set_turn_message(new_message: String):
	if game_hud != null:
		game_hud.set_turn_text(new_message)


func set_button_available(
	button: Button,
	value: bool
):
	if button == null:
		return

	if button.has_method("set_available"):
		button.set_available(value)
	else:
		button.disabled = not value


func update_action_buttons():
	if round_over:
		set_button_available(
			deck_tap_button,
			false
		)

		set_button_available(
			discard_tap_button,
			false
		)

		set_button_available(
			discard_button,
			false
		)

		discard_button.visible = false

		go_out_button.visible = true

		if game_over:
			go_out_button.text = "New Game"
		else:
			go_out_button.text = "Next Round"

		set_button_available(
			go_out_button,
			not is_animating
		)

		return

	discard_button.visible = true
	go_out_button.visible = true
	go_out_button.text = "Go Out"

	var normal_turn_available: bool = (
		not is_animating
	)

	var can_draw: bool = (
		normal_turn_available
		and not has_drawn
	)

	set_button_available(
		deck_tap_button,
		can_draw
	)

	set_button_available(
		discard_tap_button,
		can_draw
		and not discard_cards.is_empty()
	)

	var valid_discard_selected: bool = (
		selected_card != null
		and selected_card != protected_discard_pickup
	)

	set_button_available(
		discard_button,
		normal_turn_available
		and has_drawn
		and valid_discard_selected
	)

	set_button_available(
		go_out_button,
		normal_turn_available
		and has_drawn
		and valid_discard_selected
		and player_hand.can_go_out_after_discard(
			selected_card
		)
	)


func set_hand_interactable(value: bool):
	for card: Node2D in player_hand.cards:
		if card.has_method("set_interactable"):
			card.set_interactable(value)


func begin_animation_lock():
	is_animating = true
	set_hand_interactable(false)
	update_action_buttons()


func end_animation_lock():
	is_animating = false

	if not round_over:
		set_hand_interactable(true)

	update_action_buttons()


func clear_hand_cards():
	player_hand.clear_and_free()


func clear_discard_cards():
	for card: Node2D in discard_cards:
		if is_instance_valid(card):
			card.queue_free()

	discard_cards.clear()

func refresh_discard_pile_visuals():

	var visible_cards := mini(
		5,
		discard_cards.size()
	)

	for i in range(discard_cards.size()):

		var card = discard_cards[i]

		if not is_instance_valid(card):
			continue

		var depth := discard_cards.size() - 1 - i

		card.visible = depth < visible_cards

		if not card.visible:
			continue

		var x_offset := depth * -2.0
		var y_offset := depth * 1.2

		card.position = discard_position + Vector2(
			x_offset,
			y_offset
		)

		card.rotation_degrees = lerpf(
			-6.0,
			6.0,
			randf()
		)

		card.z_index = 20 + i


func animate_top_discard():

	if discard_cards.is_empty():
		return

	var top = discard_cards.back()

	if not is_instance_valid(top):
		return

	var start_rotation: float = top.rotation_degrees

	var tween := create_tween()

	tween.set_loops()

	tween.tween_property(
		top,
		"rotation_degrees",
		start_rotation + 2.0,
		1.5
	)

	tween.tween_property(
		top,
		"rotation_degrees",
		start_rotation - 2.0,
		1.5
	)


func clear_grace_hand_cards():
	for card: Node2D in grace_hand_cards:
		if is_instance_valid(card):
			card.queue_free()

	grace_hand_cards.clear()


func clear_grace_revealed_cards():
	grace_revealed_cards.clear()



func reveal_current_wild():
	if wild_marker == null:
		return

	wild_marker.reveal_rank(
		game_state.wild_rank,
		wild_reveal_sound
	)

	set_message(
		GameConfig.wild_display_name(
			game_state.wild_rank
		)
		+ " are wild!"
	)


func deal_opening_hand():
	clear_hand_cards()
	clear_discard_cards()
	clear_grace_hand_cards()
	clear_grace_revealed_cards()

	grace_hand_data.clear()
	recycled_draw_cards.clear()
	selected_card = null
	protected_discard_pickup = null
	has_drawn = false
	discard_count = 0
	round_over = false
	game_over = false

	begin_animation_lock()

	refresh_hud("Wild Reveal")
	reveal_current_wild()

	card_deck.build(1)
	card_deck.shuffle()

	var wild_reveal_delay: float = 4.25
	var reveal_timer: Tween = create_tween()

	reveal_timer.tween_interval(wild_reveal_delay)
	reveal_timer.tween_callback(
		start_alternating_opening_deal
	)


func start_alternating_opening_deal():
	refresh_hud("Dealing...")

	set_message(
		dealer_action_text(
			"You are dealing the cards.",
			"Grace is dealing the cards."
		)
	)

	var cards_to_deal: int = game_state.cards_dealt
	var deal_step_delay: float = 0.11
	var card_travel_time: float = 0.42

	for card_number: int in range(cards_to_deal):
		if player_is_dealer():
			deal_grace_opening_card(
				card_number,
				cards_to_deal,
				card_travel_time,
				float(card_number * 2)
				* deal_step_delay
			)

			deal_player_opening_card(
				card_number,
				cards_to_deal,
				card_travel_time,
				float(card_number * 2 + 1)
				* deal_step_delay
			)
		else:
			deal_player_opening_card(
				card_number,
				cards_to_deal,
				card_travel_time,
				float(card_number * 2)
				* deal_step_delay
			)

			deal_grace_opening_card(
				card_number,
				cards_to_deal,
				card_travel_time,
				float(card_number * 2 + 1)
				* deal_step_delay
			)

	player_hand.sort_default()

	var final_card_delay: float = (
		float(maxi(cards_to_deal * 2 - 1, 0))
		* deal_step_delay
	)

	var opening_discard_delay: float = (
		final_card_delay
		+ card_travel_time
		+ 0.12
	)

	var finish_deal_timer: Tween = create_tween()

	finish_deal_timer.tween_interval(
		opening_discard_delay
	)

	finish_deal_timer.tween_callback(func():
		create_opening_discard()
		arrange_hand(0.30, false, false)
	)

	finish_deal_timer.tween_interval(0.50)

	finish_deal_timer.tween_callback(func():
		set_message(
			game_state.mode_name
			+ ": "
			+ str(game_state.cards_dealt)
			+ " cards dealt. "
			+ GameConfig.wild_display_name(
				game_state.wild_rank
			)
			+ " are wild."
		)

		var turn_start_timer: Tween = create_tween()

		turn_start_timer.tween_interval(0.45)

		turn_start_timer.tween_callback(
			begin_round_play
		)
	)


func deal_grace_opening_card(
	card_number: int,
	cards_to_deal: int,
	card_travel_time: float,
	deal_delay: float
):
	var grace_card_data: Dictionary = (
		card_deck.draw_card(
			game_state.wild_rank
		)
	)

	if grace_card_data.is_empty():
		return

	grace_hand_data.append(
		grace_card_data.duplicate(true)
	)

	var grace_visual_data: Dictionary = (
		grace_card_data.duplicate(true)
	)

	grace_visual_data["face_down"] = true

	var grace_card: Node2D = create_card(
		grace_visual_data,
		false
	)

	grace_card.position = deck_position
	grace_card.rotation_degrees = (
		deal_rng.randf_range(-8.0, -4.0)
	)
	grace_card.scale = Vector2(0.78, 0.78)
	grace_card.z_index = 30 + card_number

	if grace_card.has_method("set_interactable"):
		grace_card.set_interactable(false)

	add_child(grace_card)
	grace_hand_cards.append(grace_card)

	deal_grace_card_to_position(
		grace_card,
		card_number,
		cards_to_deal,
		card_travel_time,
		deal_delay
	)


func deal_player_opening_card(
	card_number: int,
	cards_to_deal: int,
	card_travel_time: float,
	deal_delay: float
):
	var player_card_data: Dictionary = (
		card_deck.draw_card(
			game_state.wild_rank
		)
	)

	if player_card_data.is_empty():
		return

	var player_card: Node2D = create_card(
		player_card_data
	)

	player_card.position = deck_position
	player_card.rotation_degrees = (
		deal_rng.randf_range(-8.0, -4.0)
	)

	add_child(player_card)
	player_hand.add_card(player_card)

	deal_player_card_to_position(
		player_card,
		card_number,
		cards_to_deal,
		card_travel_time,
		deal_delay
	)


func deal_grace_card_to_position(
	card: Node2D,
	card_index: int,
	card_count: int,
	duration: float,
	delay: float
) -> void:
	var card_scale: float = 0.64
	var card_width: float = 82.0 * card_scale
	var side_margin: float = 26.0

	var available_spacing_width: float = (
		TABLE_WIDTH
		- side_margin * 2.0
		- card_width
	)

	var spacing: float = minf(
		31.0,
		available_spacing_width
		/ float(maxi(card_count - 1, 1))
	)

	var total_width: float = (
		spacing * float(card_count - 1)
		+ card_width
	)

	var start_x: float = (
		TABLE_WIDTH - total_width
	) / 2.0

	var center_index: float = (
		float(card_count - 1) / 2.0
	)

	var distance_from_center: float = absf(
		float(card_index) - center_index
	)

	var target: Vector2 = Vector2(
		start_x + float(card_index) * spacing,
		GRACE_HAND_Y
		+ distance_from_center * 1.0
	)

	var rotation_amount: float = 3.0

	if card_count > 7:
		rotation_amount = 2.0

	if card_count > 10:
		rotation_amount = 1.3

	var rotation: float = (
		(float(card_index) - center_index)
		* rotation_amount
	)

	card.scale = Vector2(card_scale, card_scale)
	card.z_index = 30 + card_index

	if card.has_method("deal_to"):
		card.deal_to(
			target,
			rotation,
			duration,
			delay,
			Vector2.ZERO
		)
	else:
		card.position = target
		card.rotation_degrees = rotation


func deal_player_card_to_position(
	card: Node2D,
	card_index: int,
	card_count: int,
	duration: float,
	delay: float
) -> void:
	var card_scale: float = 1.0

	if card_count >= 7:
		card_scale = 0.90

	if card_count >= 9:
		card_scale = 0.82

	if card_count >= 11:
		card_scale = 0.74

	var card_width: float = 82.0 * card_scale
	var side_margin: float = 25.0

	var available_spacing_width: float = (
		TABLE_WIDTH
		- side_margin * 2.0
		- card_width
	)

	var spacing: float = minf(
		get_hand_spacing(card_count),
		available_spacing_width
		/ float(maxi(card_count - 1, 1))
	)

	var total_width: float = (
		spacing * float(card_count - 1)
		+ card_width
	)

	var start_x: float = (
		TABLE_WIDTH - total_width
	) / 2.0

	var center_index: float = (
		float(card_count - 1) / 2.0
	)

	var half_span: float = maxf(
		center_index,
		1.0
	)

	var normalized_offset: float = (
		(float(card_index) - center_index)
		/ half_span
	)

	var maximum_rotation: float = 12.0
	var maximum_curve_depth: float = 13.0

	if card_count <= 3:
		maximum_rotation = 8.0
		maximum_curve_depth = 6.0
	elif card_count <= 5:
		maximum_rotation = 11.0
		maximum_curve_depth = 10.0
	elif card_count <= 7:
		maximum_rotation = 13.0
		maximum_curve_depth = 14.0
	elif card_count <= 9:
		maximum_rotation = 12.0
		maximum_curve_depth = 13.0
	elif card_count <= 11:
		maximum_rotation = 10.0
		maximum_curve_depth = 11.0
	else:
		maximum_rotation = 8.0
		maximum_curve_depth = 9.0

	var curve_strength: float = (
		normalized_offset * normalized_offset
	)

	var target := Vector2(
		start_x + float(card_index) * spacing,
		PLAYER_HAND_Y
		+ curve_strength * maximum_curve_depth
	)

	var rotation: float = (
		normalized_offset * maximum_rotation
	)

	card.scale = Vector2(
		card_scale,
		card_scale
	)

	card.z_index = 10 + card_index

	if card.has_method("deal_to"):
		card.deal_to(
			target,
			rotation,
			duration,
			delay,
			Vector2(
				deal_rng.randf_range(-2.0, 2.0),
				deal_rng.randf_range(-1.0, 1.0)
			)
		)
	else:
		card.position = target
		card.rotation_degrees = rotation


func create_opening_discard():
	var discard_data: Dictionary = (
		card_deck.draw_card(
			game_state.wild_rank
		)
	)

	if discard_data.is_empty():
		return

	var discard_card: Node2D = create_card(
		discard_data,
		false
	)

	discard_card.position = deck_position
	discard_card.z_index = 20

	if discard_card.has_method("set_interactable"):
		discard_card.set_interactable(false)

	add_child(discard_card)
	discard_cards.append(discard_card)

	if discard_card.has_method("fly_to"):
		discard_card.fly_to(
			discard_position,
			deal_rng.randf_range(-3.0, 3.0),
			0.40
		)
	else:
		discard_card.position = discard_position
	
	var refresh_timer: Tween = create_tween()
	refresh_timer.tween_interval(0.42)
	refresh_timer.tween_callback(
		refresh_discard_pile_visuals
	)


func begin_round_play():
	refresh_hud(
		"Grace's Turn"
		if player_is_dealer()
		else "Your Turn"
	)

	if player_is_dealer():
		begin_grace_opening_turn()
	else:
		begin_player_opening_turn()


func player_is_dealer() -> bool:
	return game_state.dealer_name().to_lower() != "grace"

func dealer_display_name() -> String:
	return (
		"You"
		if player_is_dealer()
		else "Grace"
	)


func dealer_action_text(
	player_text: String,
	grace_text: String
) -> String:
	return (
		player_text
		if player_is_dealer()
		else grace_text
	)

func begin_player_opening_turn():
	has_drawn = false
	protected_discard_pickup = null

	end_animation_lock()

	set_turn_message("Your Turn")
	set_message("Your turn. Tap the deck or discard pile.")


func begin_grace_opening_turn():
	has_drawn = false
	protected_discard_pickup = null

	set_hand_interactable(false)
	set_turn_message("Grace's Turn")
	set_message("Grace plays first this round.")

	var opening_turn_timer: Tween = create_tween()

	opening_turn_timer.tween_interval(0.55)

	opening_turn_timer.tween_callback(
		start_grace_turn
	)


func draw_game_card() -> Dictionary:
	if not recycled_draw_cards.is_empty():
		return recycled_draw_cards.pop_back()

	var drawn_data: Dictionary = (
		card_deck.draw_card(
			game_state.wild_rank
		)
	)

	if not drawn_data.is_empty():
		return drawn_data

	if not recycle_discard_pile():
		return {}

	return recycled_draw_cards.pop_back()


func recycle_discard_pile() -> bool:
	if discard_cards.size() <= 1:
		return false

	var top_discard: Node2D = discard_cards.back()
	var cards_to_recycle: Array[Node2D] = []

	for i: int in range(discard_cards.size() - 1):
		var card: Node2D = discard_cards[i]

		if is_instance_valid(card):
			cards_to_recycle.append(card)

	if cards_to_recycle.is_empty():
		return false

	for card: Node2D in cards_to_recycle:
		recycled_draw_cards.append(
			card_node_to_data(card)
		)

		card.queue_free()

	discard_cards.clear()
	discard_cards.append(top_discard)

	recycled_draw_cards.shuffle()
	discard_count = 1

	refresh_discard_pile_visuals()

	if deck_visual != null:
		if deck_visual.has_method("reset_deck"):
			deck_visual.reset_deck()
		elif deck_visual.has_method("show"):
			deck_visual.show()

	set_message(
		"The draw pile was empty, so the discard pile "
		+ "was shuffled into a new deck."
	)

	return true


func draw_card():
	if round_over or is_animating:
		return

	if has_drawn:
		set_message(
			"Discard before drawing again."
		)
		return

	var data: Dictionary = draw_game_card()

	if data.is_empty():
		set_message(
			"No cards are available to draw."
		)
		return

	begin_animation_lock()

	protected_discard_pickup = null

	if (
		deck_visual != null
		and deck_visual.has_method(
			"animate_draw"
		)
	):
		deck_visual.animate_draw()

	var card: Node2D = create_card(data)

	card.position = deck_position
	card.rotation_degrees = (
		deal_rng.randf_range(-10.0, -5.0)
	)

	add_child(card)
	player_hand.add_card(card)
	player_hand.sort_if_automatic()

	arrange_hand(0.40, false, true)

	var draw_timer: Tween = create_tween()
	draw_timer.tween_interval(0.48)

	draw_timer.tween_callback(func():
		has_drawn = true
		end_animation_lock()

		set_message(
			"You drew a wild."
			if bool(data["wild"])
			else "Choose a card to discard."
		)

		set_turn_message(
			"Choose a card to discard"
		)
	)


func take_top_discard():
	if round_over or is_animating:
		return

	if has_drawn:
		set_message(
			"Discard before drawing again."
		)
		return

	if discard_cards.is_empty():
		set_message(
			"There is no card in the discard pile."
		)
		return

	var card: Node2D = discard_cards.pop_back()
	refresh_discard_pile_visuals()

	if not is_instance_valid(card):
		set_message(
			"The discard pile is unavailable."
		)
		update_action_buttons()
		return

	begin_animation_lock()

	selected_card = null
	protected_discard_pickup = card

	card.add_to_group("hand_cards")

	card.selected.connect(
		on_card_selected
	)

	card.deselected.connect(
		on_card_deselected
	)

	if card.has_method("force_deselect"):
		card.force_deselect()

	if card.has_method("set_interactable"):
		card.set_interactable(false)

	card.scale = Vector2.ONE
	card.z_index = 10

	player_hand.add_card(card)
	player_hand.sort_if_automatic()

	arrange_hand(0.42, false, false)

	var pickup_timer: Tween = create_tween()
	pickup_timer.tween_interval(0.46)

	pickup_timer.tween_callback(func():
		has_drawn = true
		end_animation_lock()

		set_message(
			"You picked up the discard. "
			+ "You must keep that card and discard another."
		)

		set_turn_message(
			"Choose another card to discard"
		)
	)


func discard_selected_card():
	if round_over or is_animating:
		return

	if selected_card == null:
		set_message(
			"Pick a card first, honey."
		)
		return

	if not has_drawn:
		set_message(
			"Tap the deck or discard pile first."
		)
		return

	if selected_card == protected_discard_pickup:
		set_message(
			"You must keep the card taken from "
			+ "the discard pile. Choose another card."
		)
		update_action_buttons()
		return

	perform_discard(false)


func go_out_selected_card():
	if round_over or is_animating:
		return

	if selected_card == null:
		set_message(
			"Choose the card you want to discard."
		)
		return

	if not has_drawn:
		set_message(
			"Tap the deck or discard pile first."
		)
		return

	if selected_card == protected_discard_pickup:
		set_message(
			"You cannot discard the card you just "
			+ "picked up from the discard pile."
		)
		update_action_buttons()
		return

	if not player_hand.can_go_out_after_discard(
		selected_card
	):
		set_message(
			"That discard does not leave a valid hand."
		)
		update_action_buttons()
		return

	perform_discard(true)


func perform_discard(
	player_is_going_out: bool
):
	begin_animation_lock()

	var card: Node2D = selected_card

	selected_card = null
	player_hand.remove_card(card)

	if card.has_method("force_deselect"):
		card.force_deselect()

	if card.has_method("set_interactable"):
		card.set_interactable(false)

	card.remove_from_group("hand_cards")
	card.z_index = 21 + discard_count

	var settle_offset := Vector2(
		deal_rng.randf_range(-2.5, 2.5),
		deal_rng.randf_range(-1.5, 2.5)
	)

	var settle_rotation: float = (
		deal_rng.randf_range(-5.0, 5.0)
	)

	discard_count += 1
	discard_cards.append(card)

	var pile_refresh_timer: Tween = create_tween()
	pile_refresh_timer.tween_interval(0.44)
	pile_refresh_timer.tween_callback(
		refresh_discard_pile_visuals
	)

	if card.has_method("fly_to"):
		card.fly_to(
			discard_position + settle_offset,
			settle_rotation,
			0.42
		)

	var discard_timer: Tween = create_tween()
	discard_timer.tween_interval(0.42)

	discard_timer.tween_callback(func():
		has_drawn = false
		protected_discard_pickup = null
		arrange_hand(0.30, false, false)

		if player_is_going_out:
			finish_player_go_out()
			return

		set_turn_message("Grace is thinking...")

		if card.is_wild:
			set_message(
				"...Honey. You discarded a wild."
			)
		else:
			set_message(
				"Grace is studying the table."
			)
	)

	if player_is_going_out:
		return

	discard_timer.tween_interval(0.65)
	discard_timer.tween_callback(start_grace_turn)


func start_grace_turn() -> void:
	if round_over:
		return

	begin_animation_lock()

	set_turn_message("Grace's Turn")

	var top_discard_data: Dictionary = (
		get_top_discard_data()
	)

	if top_discard_data.is_empty():
		set_message(
			"Grace glances at the empty discard pile."
		)
	else:
		var opening_messages: Array[String] = [
			"Grace studies the discard pile...",
			"Grace looks over your discard...",
			"Grace considers the card on the table...",
			"Grace takes a closer look at the discard..."
		]

		set_message(
			opening_messages[
				deal_rng.randi_range(
					0,
					opening_messages.size() - 1
				)
			]
		)

	var first_think_time: float = (
		deal_rng.randf_range(
			0.55,
			0.95
		)
	)

	var think_timer: Tween = create_tween()

	think_timer.tween_interval(
		first_think_time
	)

	think_timer.tween_callback(func():
		if round_over:
			return

		var current_discard_data: Dictionary = (
			get_top_discard_data()
		)

		var take_discard: bool = false

		if not current_discard_data.is_empty():
			take_discard = (
				grace_ai.should_take_discard(
					grace_hand_data,
					current_discard_data
				)
			)

		if take_discard:
			var discard_messages: Array[String] = [
				"Grace smiles. \"I'll take that.\"",
				"Grace reaches for your discard...",
				"Grace nods and takes the card.",
				"Grace says, \"That might help.\""
			]

			set_message(
				discard_messages[
					deal_rng.randi_range(
						0,
						discard_messages.size() - 1
					)
				]
			)

			var reach_delay: float = (
				deal_rng.randf_range(
					0.25,
					0.48
				)
			)

			var reach_timer: Tween = create_tween()

			reach_timer.tween_interval(
				reach_delay
			)

			reach_timer.tween_callback(func():
				if round_over:
					return

				grace_draw_from_discard(
					current_discard_data
				)
			)
		else:
			var deck_messages: Array[String] = [
				"Grace decides to try the deck.",
				"Grace leaves the discard where it is.",
				"Grace says, \"Not this time, honey.\"",
				"Grace turns her attention to the deck."
			]

			set_message(
				deck_messages[
					deal_rng.randi_range(
						0,
						deck_messages.size() - 1
					)
				]
			)

			var deck_reach_delay: float = (
				deal_rng.randf_range(
					0.28,
					0.52
				)
			)

			var deck_reach_timer: Tween = (
				create_tween()
			)

			deck_reach_timer.tween_interval(
				deck_reach_delay
			)

			deck_reach_timer.tween_callback(func():
				if round_over:
					return

				grace_draw_from_deck()
			)
	)


func get_top_discard_data() -> Dictionary:
	if discard_cards.is_empty():
		return {}

	var top_card: Node2D = discard_cards.back()

	if not is_instance_valid(top_card):
		return {}

	return card_node_to_data(top_card)


func card_node_to_data(
	card: Node2D
) -> Dictionary:
	return {
		"rank": String(card.rank),
		"suit": String(card.suit),
		"card_id": String(card.card_id),
		"wild": bool(card.is_wild)
	}

func add_grace_draw_visual(
	start_position: Vector2
) -> Node2D:
	var visual_data: Dictionary = {
		"rank": "",
		"suit": "",
		"card_id": "",
		"wild": false,
		"face_down": true
	}

	var card: Node2D = create_card(
		visual_data,
		false
	)

	card.position = start_position
	card.scale = Vector2(0.78, 0.78)
	card.z_index = 30 + grace_hand_cards.size()

	if card.has_method("set_interactable"):
		card.set_interactable(false)

	add_child(card)
	grace_hand_cards.append(card)

	arrange_grace_hidden_hand(
		0.36,
		false
	)

	return card

func arrange_grace_hidden_hand(
	duration: float = 0.30,
	stagger: bool = false
) -> void:

	var count := grace_hand_cards.size()

	if count == 0:
		return

	var card_scale := 0.64
	var card_width := 82.0 * card_scale
	var side_margin := 26.0

	var available_width := (
		TABLE_WIDTH
		- side_margin * 2.0
		- card_width
	)

	var spacing := minf(
		26.0,
		available_width / float(maxi(count - 1, 1))
	)

	var total_width := spacing * float(count - 1) + card_width
	var start_x := (TABLE_WIDTH - total_width) / 2.0

	var center := float(count - 1) / 2.0

	for i in range(count):

		var card: Node2D = grace_hand_cards[i]

		if !is_instance_valid(card):
			continue

		var offset := float(i) - center
		var distance := absf(offset)

		var target := Vector2(
			start_x + float(i) * spacing,
			GRACE_HAND_Y + distance * 3.0
		)

		var rotation := offset * 5.0

		if count >= 8:
			rotation *= 0.9

		if count >= 11:
			rotation *= 0.8

		var delay := 0.0

		if stagger:
			delay = float(i) * 0.025

		card.scale = Vector2(card_scale, card_scale)
		card.z_index = 30 + i

		if card.has_method("move_to"):
			card.move_to(
				target,
				rotation,
				duration,
				delay
			)
		else:
			card.position = target
			card.rotation_degrees = rotation


func grace_draw_from_discard(
	discard_data: Dictionary
):
	if discard_data.is_empty():
		grace_draw_from_deck()
		return

	var top_card: Node2D = discard_cards.pop_back()
	refresh_discard_pile_visuals()

	grace_hand_data.append(
		discard_data.duplicate(true)
	)

	set_message(
		"Grace takes your discard."
	)

	var protected_index: int = (
		grace_hand_data.size() - 1
	)

	var drawn_visual: Node2D = add_grace_draw_visual(
		discard_position
	)

	if is_instance_valid(top_card):
		if top_card.has_method("fly_to"):
			top_card.fly_to(
				Vector2(195, 205),
				0.0,
				0.30
			)

		var cleanup_timer: Tween = create_tween()

		cleanup_timer.tween_interval(0.32)

		cleanup_timer.tween_callback(func():
			if is_instance_valid(top_card):
				top_card.queue_free()

			if is_instance_valid(drawn_visual):
				arrange_grace_hidden_hand(
					0.30,
					false
				)

			set_message(
				"Grace rearranges her hand..."
			)
		)

		cleanup_timer.tween_interval(0.55)

		cleanup_timer.tween_callback(func():
			grace_choose_discard(
				protected_index
			)
		)
	else:
		set_message(
			"Grace rearranges her hand..."
		)

		var pause_timer: Tween = create_tween()

		pause_timer.tween_interval(0.55)

		pause_timer.tween_callback(func():
			grace_choose_discard(
				protected_index
			)
		)


func grace_draw_from_deck():
	var drawn_data: Dictionary = draw_game_card()

	if drawn_data.is_empty():
		end_animation_lock()
		set_turn_message("Your Turn")

		set_message(
			"No cards are available for Grace to draw. "
			+ "Your turn. Tap the discard pile."
		)
		return

	grace_hand_data.append(
		drawn_data.duplicate(true)
	)

	if (
		deck_visual != null
		and deck_visual.has_method(
			"animate_draw"
		)
	):
		deck_visual.animate_draw()

	add_grace_draw_visual(
		deck_position
	)

	set_message(
		"Grace draws from the deck."
	)

	var think_timer: Tween = create_tween()

	think_timer.tween_interval(0.65)

	think_timer.tween_callback(func():
		set_message(
			"Grace studies her hand..."
		)
	)

	think_timer.tween_interval(0.55)

	think_timer.tween_callback(func():
		grace_choose_discard(-1)
	)


func grace_choose_discard(
	protected_index: int
):
	set_message(
		"Grace studies her cards..."
	)

	var discard_index: int = (
		grace_ai.choose_discard_index(
			grace_hand_data,
			protected_index
		)
	)

	if discard_index < 0:
		end_animation_lock()
		set_turn_message("Your Turn")
		set_message("Your turn. Draw a card.")
		return

	var discard_data: Dictionary = (
		grace_hand_data[
			discard_index
		].duplicate(true)
	)

	grace_hand_data.remove_at(
		discard_index
	)

	var discard_visual: Node2D = null

	if (
		discard_index >= 0
		and discard_index < grace_hand_cards.size()
	):
		discard_visual = grace_hand_cards[
			discard_index
		]

		grace_hand_cards.remove_at(
			discard_index
		)

	arrange_grace_hidden_hand(
		0.30,
		false
	)

	var grace_is_going_out: bool = (
		grace_ai.can_go_out(
			grace_hand_data
		)
	)

	var think_timer: Tween = create_tween()

	think_timer.tween_interval(0.55)

	think_timer.tween_callback(func():
		grace_discard_card(
			discard_data,
			grace_is_going_out,
			discard_visual
		)
	)


func grace_discard_card(
	discard_data: Dictionary,
	grace_is_going_out: bool,
	discard_visual: Node2D
):
	set_message(
		"Grace pauses before discarding..."
	)

	var hesitation_timer: Tween = create_tween()

	hesitation_timer.tween_interval(0.35)

	hesitation_timer.tween_callback(func():
		var card: Node2D = discard_visual

		if not is_instance_valid(card):
			card = create_card(
				discard_data,
				false
			)

			card.position = Vector2(
				195,
				205
			)

			add_child(card)

		card.configure(
			discard_data
		)

		card.scale = Vector2(
			0.82,
			0.82
		)

		card.z_index = (
			21 + discard_count
		)

		if card.has_method("set_interactable"):
			card.set_interactable(false)

		var settle_offset := Vector2(
			deal_rng.randf_range(
				-2.5,
				2.5
			),
			deal_rng.randf_range(
				-1.5,
				2.5
			)
		)

		var settle_rotation: float = (
			deal_rng.randf_range(
				-5.0,
				5.0
			)
		)

		discard_count += 1
		discard_cards.append(card)

		if card.has_method("flip_face_up"):
			card.flip_face_up()

		if card.has_method("fly_to"):
			card.fly_to(
				discard_position
				+ settle_offset,
				settle_rotation,
				0.42
			)
		else:
			card.position = (
				discard_position
				+ settle_offset
			)

			card.rotation_degrees = (
				settle_rotation
			)

		var pile_refresh_timer: Tween = (
			create_tween()
		)

		pile_refresh_timer.tween_interval(
			0.44
		)

		pile_refresh_timer.tween_callback(
			refresh_discard_pile_visuals
		)

		set_message(
			"Grace discards "
			+ String(
				discard_data.get(
					"rank",
					""
				)
			)
			+ String(
				discard_data.get(
					"suit",
					""
				)
			)
			+ "."
		)

		var finish_timer: Tween = (
			create_tween()
		)

		finish_timer.tween_interval(
			0.50
		)

		finish_timer.tween_callback(func():
			if grace_is_going_out:
				finish_grace_go_out()
				return

			end_animation_lock()
			set_turn_message("Your Turn")

			set_message(
				"Your turn. Draw a card."
			)
		)
	)


func finish_player_go_out():
	round_winner_index = 0
	round_over = true
	is_animating = true

	set_hand_interactable(false)
	set_turn_message("You Went Out!")
	set_message(
		"You went out! Grace is showing her hand."
	)

	pulse_player_melds()
	reveal_grace_hand()

func finish_grace_go_out():
	round_winner_index = 1
	round_over = true
	is_animating = true

	set_hand_interactable(false)
	set_turn_message("Grace Went Out")
	set_message(
		"Grace went out. She is showing her hand."
	)

	reveal_grace_hand()


func reveal_grace_hand():
	clear_grace_revealed_cards()

	var reveal_count: int = mini(
		grace_hand_cards.size(),
		grace_hand_data.size()
	)

	for i: int in range(reveal_count):
		var card: Node2D = grace_hand_cards[i]
		var data: Dictionary = grace_hand_data[i]

		if not is_instance_valid(card):
			continue

		var reveal_data: Dictionary = data.duplicate(true)
		reveal_data["face_down"] = true

		card.configure(reveal_data)
		card.scale = Vector2(0.72, 0.72)

		if card.has_method("set_interactable"):
			card.set_interactable(false)

		grace_revealed_cards.append(card)

	arrange_grace_hand()

	var reveal_sequence: Tween = create_tween()

	reveal_sequence.tween_interval(0.25)

	for i: int in range(grace_revealed_cards.size()):
		var card: Node2D = grace_revealed_cards[i]

		reveal_sequence.parallel().tween_callback(
			flip_grace_reveal_card.bind(card)
		).set_delay(
			0.10 * float(i)
		)

	var total_reveal_time: float = (
		0.10
		* float(
			maxi(
				grace_revealed_cards.size() - 1,
				0
			)
		)
		+ 0.42
	)

	reveal_sequence.tween_interval(total_reveal_time)

	reveal_sequence.tween_callback(
		complete_round_scoring
	)


func flip_grace_reveal_card(card: Node2D):
	if not is_instance_valid(card):
		return

	var card_index: int = (
		grace_revealed_cards.find(card)
	)

	if card_index < 0:
		return

	card.z_index = 80 + card_index

	if card.has_method("flip_to_face"):
		card.flip_to_face()

	var settle_tween: Tween = create_tween()

	settle_tween.tween_property(
		card,
		"scale",
		Vector2(0.77, 0.77),
		0.14
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_OUT
	)

	settle_tween.tween_property(
		card,
		"scale",
		Vector2(0.72, 0.72),
		0.16
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_IN_OUT
	)

	settle_tween.tween_callback(func():
		if is_instance_valid(card):
			card.z_index = 40 + card_index
	)


func arrange_grace_hand():
	var count: int = grace_revealed_cards.size()

	if count == 0:
		return

	var card_width: float = 82.0 * 0.72
	var screen_width: float = 390.0
	var side_margin: float = 20.0

	var available_spacing_width: float = (
		screen_width
		- side_margin * 2.0
		- card_width
	)

	var spacing: float = minf(
		43.0,
		available_spacing_width
		/ float(maxi(count - 1, 1))
	)

	var total_width: float = (
		spacing * float(count - 1)
		+ card_width
	)

	var start_x: float = (
		screen_width - total_width
	) / 2.0

	var center_index: float = (
		float(count - 1) / 2.0
	)

	for i: int in range(count):
		var card: Node2D = grace_revealed_cards[i]
		var card_index: float = float(i)

		if not is_instance_valid(card):
			continue

		var distance_from_center: float = abs(
			card_index - center_index
		)

		var target := Vector2(
			start_x + card_index * spacing,
			207.0 + distance_from_center * 1.5
		)

		var rotation: float = (
			(card_index - center_index)
			* get_grace_rotation_amount(count)
		)

		card.z_index = 40 + i

		if card.has_method("move_to"):
			card.move_to(
				target,
				rotation,
				0.38,
				0.025 * card_index
			)
		else:
			card.position = target
			card.rotation_degrees = rotation


func complete_round_scoring():
	var player_round_score := 0
	var grace_round_score := 0

	if round_winner_index == 0:
		grace_round_score = (
			ScoreCalculator.losing_round_score(
				grace_revealed_cards
			)
		)
	else:
		player_round_score = (
			ScoreCalculator.losing_round_score(
				player_hand.cards
			)
		)

	game_state.add_round_scores(
		player_round_score,
		grace_round_score
	)

	game_over = game_state.is_game_over()
	is_animating = false

	var score_text: String = (
		"Round score — You: "
		+ str(player_round_score)
		+ ", Grace: "
		+ str(grace_round_score)
		+ ". Total — You: "
		+ str(game_state.player_scores[0])
		+ ", Grace: "
		+ str(game_state.player_scores[1])
		+ "."
	)

	if game_over:
		set_turn_message("Game Over")
		set_message(
			score_text
			+ " "
			+ game_state.winner_text()
		)
	else:
		set_turn_message("Round Complete")
		set_message(score_text)

	update_action_buttons()



func on_primary_button_pressed():
	if is_animating:
		return

	if round_over:
		if game_over:
			restart_game()
		else:
			start_next_round()

		return

	go_out_selected_card()


func start_next_round():
	if is_animating:
		return

	begin_animation_lock()

	if not game_state.advance_round():
		game_over = true
		is_animating = false
		update_action_buttons()
		return

	set_turn_message("Next Round")

	set_message(
		dealer_action_text(
			"You are gathering the cards.",
			"Grace is gathering the cards."
		)
	)

	var transition: Tween = create_tween()

	transition.tween_interval(0.45)

	transition.tween_callback(func():
		refresh_hud("Shuffling...")

		set_message(
			dealer_action_text(
				"You are shuffling for round "
				+ str(game_state.current_round)
				+ ".",
				"Grace is shuffling for round "
				+ str(game_state.current_round)
				+ "."
			)
		)

		deal_opening_hand()
	)


func restart_game():
	if is_animating:
		return

	begin_animation_lock()

	set_turn_message("New Game")
	set_message("Grace is gathering the cards.")

	var transition: Tween = create_tween()

	transition.tween_interval(0.45)

	transition.tween_callback(func():
		initialize_game_state()
		refresh_hud("Shuffling...")

		set_message(
			dealer_action_text(
				"You are shuffling a new game.",
				"Grace is shuffling a new game."
			)
		)

		deal_opening_hand()
	)


func pulse_player_melds():
	var meld_groups: Array[Array] = (
		player_hand.get_meld_groups()
	)

	for group: Array in meld_groups:
		for card in group:
			if (
				is_instance_valid(card)
				and card.has_method("pulse")
			):
				card.pulse()


func arrange_hand(
	duration: float = 0.28,
	stagger: bool = false,
	use_deal_animation: bool = false
) -> void:
	var count: int = player_hand.size()

	if count == 0:
		return

	var card_scale: float = 1.0

	if count >= 7:
		card_scale = 0.90

	if count >= 9:
		card_scale = 0.82

	if count >= 11:
		card_scale = 0.74

	var card_width: float = 82.0 * card_scale
	var side_margin: float = 25.0

	var available_spacing_width: float = (
		TABLE_WIDTH
		- side_margin * 2.0
		- card_width
	)

	var spacing: float = minf(
		get_hand_spacing(count),
		available_spacing_width
		/ float(maxi(count - 1, 1))
	)

	var total_width: float = (
		spacing * float(count - 1)
		+ card_width
	)

	var start_x: float = (
		TABLE_WIDTH - total_width
	) / 2.0

	var center_index: float = (
		float(count - 1) / 2.0
	)

	var half_span: float = maxf(
		center_index,
		1.0
	)

	var maximum_rotation: float = 12.0
	var maximum_curve_depth: float = 13.0

	if count <= 3:
		maximum_rotation = 8.0
		maximum_curve_depth = 6.0
	elif count <= 5:
		maximum_rotation = 11.0
		maximum_curve_depth = 10.0
	elif count <= 7:
		maximum_rotation = 13.0
		maximum_curve_depth = 14.0
	elif count <= 9:
		maximum_rotation = 12.0
		maximum_curve_depth = 13.0
	elif count <= 11:
		maximum_rotation = 10.0
		maximum_curve_depth = 11.0
	else:
		maximum_rotation = 8.0
		maximum_curve_depth = 9.0

	for i: int in range(count):
		var card: Node2D = player_hand.cards[i]

		if not is_instance_valid(card):
			continue

		var card_index: float = float(i)

		var normalized_offset: float = (
			(card_index - center_index)
			/ half_span
		)

		var curve_strength: float = (
			normalized_offset * normalized_offset
		)

		var target: Vector2 = Vector2(
			start_x + card_index * spacing,
			PLAYER_HAND_Y
			+ curve_strength * maximum_curve_depth
		)

		var rotation: float = (
			normalized_offset * maximum_rotation
		)

		var card_delay: float = 0.0

		if stagger:
			card_delay = card_index * 0.045

		var deal_variation: Vector2 = Vector2(
			deal_rng.randf_range(-2.0, 2.0),
			deal_rng.randf_range(-1.0, 1.0)
		)

		if card == selected_card:
			card.z_index = 100
			continue

		card.scale = Vector2(
			card_scale,
			card_scale
		)

		card.z_index = 10 + i

		if (
			use_deal_animation
			and card.has_method("deal_to")
		):
			card.deal_to(
				target,
				rotation,
				duration,
				card_delay,
				deal_variation
			)
		elif card.has_method("move_to"):
			card.move_to(
				target,
				rotation,
				duration,
				card_delay
			)
		else:
			card.position = target
			card.rotation_degrees = rotation


func get_hand_spacing(
	card_count: int
) -> float:
	if card_count <= 3:
		return 72.0

	if card_count <= 5:
		return 55.0

	if card_count <= 7:
		return 39.0

	if card_count <= 9:
		return 29.0

	if card_count <= 11:
		return 22.0

	return 19.0


func get_curve_amount(
	card_count: int
) -> float:
	if card_count <= 5:
		return 8.0

	if card_count <= 9:
		return 4.5

	return 2.5


func get_grace_rotation_amount(
	card_count: int
) -> float:
	if card_count <= 5:
		return 4.0

	if card_count <= 9:
		return 2.5

	return 1.4


func create_card(
	data: Dictionary,
	add_to_hand_group: bool = true
) -> Node2D:
	var card: Node2D = CardScene.instantiate()

	card.configure(data)

	if add_to_hand_group:
		card.add_to_group("hand_cards")

		card.selected.connect(
			on_card_selected
		)

		card.deselected.connect(
			on_card_deselected
		)

	return card



func on_card_selected(
	card: Node2D
) -> void:
	if round_over or is_animating:
		return

	if (
		selected_card != null
		and selected_card != card
	):
		selected_card.deselect()

	selected_card = card

	if card == protected_discard_pickup:
		set_message(
			"You must keep the card taken from "
			+ "the discard pile. Select another card."
		)
	elif (
		has_drawn
		and player_hand.can_go_out_after_discard(card)
	):
		set_message(
			"That discard lets you go out!"
		)
	else:
		set_message("Selected card.")

	update_action_buttons()


func on_card_deselected(
	card: Node2D
) -> void:
	if selected_card != card:
		return

	selected_card = null

	arrange_hand(
		0.18,
		false,
		false
	)

	set_message("Card deselected.")

	update_action_buttons()


func add_label(
	text_value: String,
	pos: Vector2,
	color: Color,
	size: int
) -> Label:
	var label: Label = Label.new()

	label.text = text_value
	label.position = pos

	label.add_theme_font_size_override(
		"font_size",
		size
	)

	label.add_theme_color_override(
		"font_color",
		color
	)

	label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	add_child(label)

	return label