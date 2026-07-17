extends Node2D

const CardScene := preload("res://scenes/Card.tscn")
const DeckScene := preload("res://scenes/Deck.tscn")
const DiscardPileScene := preload("res://scenes/DiscardPile.tscn")
const MessageBannerScene := preload("res://scenes/MessageBanner.tscn")
const ActionButtonScene := preload("res://scenes/ActionButton.tscn")
const PlayerSeatScene := preload("res://scenes/PlayerSeat.tscn")
const RoomBackgroundScene := preload("res://scenes/RoomBackground.tscn")
const WoodTableScene := preload("res://scenes/WoodTable.tscn")
const GameHudScene := preload("res://scenes/GameHud.tscn")
const AmbientEffectsScene := preload("res://scenes/AmbientEffects.tscn")
const TablePropsScene := preload("res://scenes/TableProps.tscn")

var cranberry := Color("#7A1E2C")
var cream := Color("#F4E7D3")
var gold := Color("#D8A441")
var walnut_dark := Color("#2B160D")

var deck_position := Vector2(103, 292)
var discard_position := Vector2(215, 292)
var hand_position := Vector2(195, 526)

var game_hud: Node2D
var deck_visual: Node2D
var message_banner: Node2D

var draw_button: Button
var discard_button: Button

var game_settings: Dictionary = {}
var game_state := GameState.new()
var card_deck := CardDeck.new()

var hand_cards: Array[Node2D] = []
var grace_hand_data: Array[Dictionary] = []
var discard_cards: Array[Node2D] = []

var selected_card: Node2D = null

var discard_count := 0
var has_drawn := false
var is_animating := false

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
	build_hand_marker()
	build_message()
	build_buttons()

	deal_opening_hand()

func read_game_settings():
	if has_meta("game_settings"):
		game_settings = get_meta("game_settings").duplicate(true)
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

func build_title():
	add_label(
		"Wild Hands",
		Vector2(81, 28),
		cranberry,
		39
	)

	add_label(
		"Friday Night at Grace's",
		Vector2(104, 75),
		Color("#2E1B12"),
		17
	)

func build_hud():
	game_hud = GameHudScene.instantiate()
	game_hud.position = Vector2(20, 123)
	game_hud.z_index = 95
	add_child(game_hud)

	refresh_hud("Your Turn")

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

func build_players():
	add_player_seat("", "🔥", Vector2(24, 191))
	add_player_seat("", "🍪", Vector2(334, 191))

func add_player_seat(
	display_name: String,
	accent_icon: String,
	pos: Vector2
):
	var seat: Node2D = PlayerSeatScene.instantiate()

	seat.position = pos
	seat.configure(display_name, accent_icon)
	seat.z_index = 96
	add_child(seat)

func build_deck_and_discard():
	deck_visual = DeckScene.instantiate()
	deck_visual.position = deck_position
	deck_visual.z_index = 2
	add_child(deck_visual)

	add_label(
		"Deck",
		Vector2(
			deck_position.x + 24,
			deck_position.y + 125
		),
		cream,
		14
	)

	var discard_slot: Node2D = (
		DiscardPileScene.instantiate()
	)
	discard_slot.position = discard_position
	discard_slot.z_index = 2
	add_child(discard_slot)

	add_label(
		"Discard",
		Vector2(
			discard_position.x + 14,
			discard_position.y + 125
		),
		cream,
		14
	)

func build_hand_marker():
	var marker_shadow: Label = add_label(
		"YOUR HAND",
		Vector2(145, 492),
		walnut_dark,
		14
	)

	marker_shadow.size = Vector2(102, 22)
	marker_shadow.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	var marker: Label = add_label(
		"YOUR HAND",
		Vector2(143, 490),
		gold,
		14
	)

	marker.size = Vector2(102, 22)
	marker.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

func build_message():
	message_banner = MessageBannerScene.instantiate()
	message_banner.position = Vector2(35, 700)
	message_banner.z_index = 100
	add_child(message_banner)

	set_message("Grace is shuffling the deck.")

func build_buttons():
	draw_button = ActionButtonScene.instantiate()
	draw_button.text = "Draw"
	draw_button.position = Vector2(69, 754)
	draw_button.z_index = 110
	draw_button.pressed.connect(draw_card)
	add_child(draw_button)

	discard_button = ActionButtonScene.instantiate()
	discard_button.text = "Discard"
	discard_button.position = Vector2(221, 754)
	discard_button.z_index = 110
	discard_button.pressed.connect(
		discard_selected_card
	)
	add_child(discard_button)

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
	set_button_available(
		draw_button,
		not is_animating and not has_drawn
	)

	set_button_available(
		discard_button,
		not is_animating
		and has_drawn
		and selected_card != null
	)

func set_hand_interactable(value: bool):
	for card: Node2D in hand_cards:
		if card.has_method("set_interactable"):
			card.set_interactable(value)

func begin_animation_lock():
	is_animating = true
	set_hand_interactable(false)
	update_action_buttons()

func end_animation_lock():
	is_animating = false
	set_hand_interactable(true)
	update_action_buttons()

func clear_hand_cards():
	for card: Node2D in hand_cards:
		if is_instance_valid(card):
			card.queue_free()

	hand_cards.clear()

func clear_discard_cards():
	for card: Node2D in discard_cards:
		if is_instance_valid(card):
			card.queue_free()

	discard_cards.clear()

func deal_opening_hand():
	clear_hand_cards()
	clear_discard_cards()

	grace_hand_data.clear()
	selected_card = null
	has_drawn = false
	discard_count = 0

	begin_animation_lock()

	card_deck.build(1)
	card_deck.shuffle()

	for card_number: int in range(
		game_state.cards_dealt
	):
		var grace_card_data: Dictionary = (
			card_deck.draw_card(game_state.wild_rank)
		)

		grace_hand_data.append(grace_card_data)

		var player_card_data: Dictionary = (
			card_deck.draw_card(game_state.wild_rank)
		)

		var player_card: Node2D = create_card(
			player_card_data
		)

		player_card.position = deck_position
		player_card.rotation_degrees = (
			deal_rng.randf_range(-8.0, -4.0)
		)

		add_child(player_card)
		hand_cards.append(player_card)

	create_opening_discard()
	arrange_hand(0.46, true, true)

	var total_deal_time: float = (
		0.46
		+ (
			0.045
			* float(
				maxi(
					game_state.cards_dealt - 1,
					0
				)
			)
		)
		+ 0.18
	)

	var deal_timer: Tween = create_tween()
	deal_timer.tween_interval(total_deal_time)

	deal_timer.tween_callback(func():
		end_animation_lock()
		refresh_hud("Your Turn")

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
	)

func create_opening_discard():
	var discard_data: Dictionary = card_deck.draw_card(
		game_state.wild_rank
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

func draw_card():
	if is_animating:
		return

	if has_drawn:
		set_message("Discard before drawing again.")
		return

	var data: Dictionary = card_deck.draw_card(
		game_state.wild_rank
	)

	if data.is_empty():
		set_message(
			"The draw pile is empty."
		)
		return

	begin_animation_lock()

	if (
		deck_visual != null
		and deck_visual.has_method("animate_draw")
	):
		deck_visual.animate_draw()

	var card: Node2D = create_card(data)

	card.position = deck_position
	card.rotation_degrees = (
		deal_rng.randf_range(-10.0, -5.0)
	)

	add_child(card)
	hand_cards.append(card)

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

func discard_selected_card():
	if is_animating:
		return

	if selected_card == null:
		set_message("Pick a card first, honey.")
		return

	if not has_drawn:
		set_message("Draw first, honey.")
		return

	begin_animation_lock()

	var card: Node2D = selected_card

	selected_card = null
	hand_cards.erase(card)

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

	if card.has_method("fly_to"):
		card.fly_to(
			discard_position + settle_offset,
			settle_rotation,
			0.42
		)

	var discard_timer: Tween = create_tween()
	discard_timer.tween_interval(0.42)

	discard_timer.tween_callback(func():
		if card.is_wild:
			set_message(
				"...Honey. You discarded a wild."
			)
		else:
			set_message(
				"Card discarded. Grace is thinking."
			)

		set_turn_message("Grace is thinking...")
		has_drawn = false
		arrange_hand(0.30, false, false)
	)

	discard_timer.tween_interval(0.42)

	discard_timer.tween_callback(func():
		end_animation_lock()
		set_turn_message("Your Turn")
		set_message("Your turn. Draw a card.")
	)

func arrange_hand(
	duration: float = 0.28,
	stagger: bool = false,
	use_deal_animation: bool = false
):
	var count: int = hand_cards.size()

	if count == 0:
		return

	var spacing: float = get_hand_spacing(count)

	var total_width: float = (
		spacing * float(count - 1)
	)

	var start_x: float = (
		hand_position.x - total_width / 2.0
	)

	var center_index: float = (
		float(count - 1) / 2.0
	)

	for i: int in range(count):
		var card: Node2D = hand_cards[i]
		var card_index: float = float(i)

		var distance_from_center: float = abs(
			card_index - center_index
		)

		var curve_offset: float = (
			distance_from_center
			* get_curve_amount(count)
		)

		var target := Vector2(
			start_x + card_index * spacing,
			hand_position.y + curve_offset
		)

		var rotation: float = (
			(card_index - center_index)
			* get_rotation_amount(count)
		)

		var delay: float = (
			0.045 * card_index
			if stagger
			else 0.0
		)

		var deal_variation := Vector2(
			deal_rng.randf_range(-3.0, 3.0),
			deal_rng.randf_range(-2.0, 2.0)
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
				delay,
				deal_variation
			)
		elif card.has_method("move_to"):
			card.move_to(
				target,
				rotation,
				duration,
				delay
			)

func get_hand_spacing(card_count: int) -> float:
	if card_count <= 3:
		return 88.0

	if card_count <= 5:
		return 68.0

	if card_count <= 7:
		return 49.0

	if card_count <= 10:
		return 34.0

	return 25.0

func get_curve_amount(card_count: int) -> float:
	if card_count <= 5:
		return 8.0

	if card_count <= 9:
		return 4.5

	return 2.5

func get_rotation_amount(card_count: int) -> float:
	if card_count <= 5:
		return 8.0

	if card_count <= 9:
		return 4.0

	return 2.25

func create_card(
	data: Dictionary,
	add_to_hand_group: bool = true
) -> Node2D:
	var card: Node2D = CardScene.instantiate()

	card.configure(data)

	if add_to_hand_group:
		card.add_to_group("hand_cards")
		card.selected.connect(on_card_selected)
		card.deselected.connect(on_card_deselected)

	return card

func on_card_selected(card: Node2D):
	if is_animating:
		return

	if (
		selected_card != null
		and selected_card != card
	):
		selected_card.deselect()

	selected_card = card
	set_message("Selected card.")
	update_action_buttons()

func on_card_deselected(card: Node2D):
	if selected_card == card:
		selected_card = null
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