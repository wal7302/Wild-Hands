extends Node2D

const CardScene := preload("res://scenes/Card.tscn")
const DeckScene := preload("res://scenes/Deck.tscn")
const DiscardPileScene := preload("res://scenes/DiscardPile.tscn")
const MessageBannerScene := preload("res://scenes/MessageBanner.tscn")
const ActionButtonScene := preload("res://scenes/ActionButton.tscn")
const PlayerSeatScene := preload("res://scenes/PlayerSeat.tscn")

var cranberry := Color("#7A1E2C")
var cream := Color("#F4E7D3")
var room_gold := Color("#F7E0BD")
var room_shadow := Color("#D6AE75")
var walnut := Color("#6B3F24")
var walnut_light := Color("#8A5735")
var walnut_dark := Color("#3B2114")
var gold := Color("#D8A441")
var card_white := Color("#FFFDF7")

var deck_position := Vector2(158, 350)
var discard_position := Vector2(232, 350)
var hand_position := Vector2(195, 610)

var message_banner: Node2D
var hand_cards: Array = []
var selected_card: Node2D = null
var discard_count := 0
var has_drawn := false
var draw_index := 0

var draw_cards := [
	{"id": "8H", "rank": "8", "suit": "♥", "wild": false},
	{"id": "3S", "rank": "3", "suit": "♠", "wild": true},
	{"id": "QC", "rank": "Q", "suit": "♣", "wild": false}
]

func _ready():
	draw_room()
	draw_title()
	draw_table()
	draw_players()
	draw_deck_and_discard()
	draw_buttons()
	draw_message()
	deal_opening_hand()

func draw_room():
	var bg: ColorRect = ColorRect.new()
	bg.color = cream
	bg.size = Vector2(390, 844)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var room_shadow_panel: ColorRect = ColorRect.new()
	room_shadow_panel.color = room_shadow
	room_shadow_panel.position = Vector2(24, 151)
	room_shadow_panel.size = Vector2(354, 560)
	room_shadow_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(room_shadow_panel)

	var room: ColorRect = ColorRect.new()
	room.color = room_gold
	room.position = Vector2(18, 145)
	room.size = Vector2(354, 560)
	room.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(room)

	for i: int in range(8):
		var glow: Line2D = Line2D.new()
		glow.width = 1
		glow.default_color = Color(1, 1, 1, 0.08)
		glow.points = PackedVector2Array([
			Vector2(24, 160 + (i * 64)),
			Vector2(366, 160 + (i * 64))
		])
		add_child(glow)

func draw_title():
	add_label("Wild Hands", Vector2(78, 42), cranberry, 42)
	add_label("Friday Night at Grace's", Vector2(100, 94), Color("#2E1B12"), 18)

func draw_table():
	var shadow: Polygon2D = Polygon2D.new()
	shadow.color = Color(0, 0, 0, 0.18)
	shadow.polygon = PackedVector2Array([
		Vector2(76, 225),
		Vector2(330, 225),
		Vector2(358, 405),
		Vector2(320, 645),
		Vector2(86, 645),
		Vector2(48, 405)
	])
	add_child(shadow)

	var table: Polygon2D = Polygon2D.new()
	table.color = walnut
	table.polygon = PackedVector2Array([
		Vector2(68, 215),
		Vector2(322, 215),
		Vector2(350, 395),
		Vector2(312, 635),
		Vector2(78, 635),
		Vector2(40, 395)
	])
	add_child(table)

	var table_highlight: Line2D = Line2D.new()
	table_highlight.width = 3
	table_highlight.default_color = walnut_light
	table_highlight.closed = true
	table_highlight.points = table.polygon
	add_child(table_highlight)

	var rim: Line2D = Line2D.new()
	rim.width = 10
	rim.default_color = walnut_dark
	rim.closed = true
	rim.points = table.polygon
	add_child(rim)

	for i: int in range(6):
		var grain: Line2D = Line2D.new()
		grain.width = 2
		grain.default_color = Color(0.24, 0.12, 0.06, 0.22)
		grain.points = PackedVector2Array([
			Vector2(80, 255 + (i * 55)),
			Vector2(310, 245 + (i * 57))
		])
		add_child(grain)

func draw_players():
	add_player_seat("🍷 Grace", "", Vector2(145, 235))
	add_player_seat("🙂 You", "", Vector2(160, 665))
	add_player_seat("", "🔥", Vector2(42, 166))
	add_player_seat("", "🍪", Vector2(312, 166))

func add_player_seat(display_name: String, accent_icon: String, pos: Vector2):
	var seat: Node2D = PlayerSeatScene.instantiate()
	seat.position = pos
	seat.configure(display_name, accent_icon)
	add_child(seat)

func draw_deck_and_discard():
	var deck: Node2D = DeckScene.instantiate()
	deck.position = deck_position
	add_child(deck)

	add_label("Deck", Vector2(deck_position.x + 8, deck_position.y + 108), cream, 14)

	var discard: Node2D = DiscardPileScene.instantiate()
	discard.position = discard_position
	add_child(discard)

	add_label("Discard", Vector2(discard_position.x + 2, discard_position.y + 108), cream, 14)
	add_label("3s Wild", Vector2(146, 468), cream, 24)

func draw_buttons():
	var draw_button: Button = ActionButtonScene.instantiate()
	draw_button.text = "Draw"
	draw_button.position = Vector2(72, 748)
	draw_button.pressed.connect(draw_card)
	add_child(draw_button)

	var discard_button: Button = ActionButtonScene.instantiate()
	discard_button.text = "Discard"
	discard_button.position = Vector2(218, 748)
	discard_button.pressed.connect(discard_selected_card)
	add_child(discard_button)

func draw_message():
	message_banner = MessageBannerScene.instantiate()
	message_banner.position = Vector2(35, 702)
	add_child(message_banner)
	set_message("Grace deals one card at a time.")

func set_message(new_message: String):
	if message_banner != null:
		message_banner.set_message(new_message)

func deal_opening_hand():
	for child: Node in get_tree().get_nodes_in_group("hand_cards"):
		child.queue_free()

	hand_cards.clear()
	selected_card = null
	has_drawn = false
	discard_count = 0

	var cards: Array = [
		{"id": "3H", "rank": "3", "suit": "♥", "wild": true},
		{"id": "7C", "rank": "7", "suit": "♣", "wild": false},
		{"id": "KD", "rank": "K", "suit": "♦", "wild": false}
	]

	for i: int in range(cards.size()):
		var card: Node2D = create_card(cards[i])
		card.position = deck_position
		add_child(card)
		hand_cards.append(card)

	arrange_hand(0.45, true)

func draw_card():
	if has_drawn:
		set_message("Discard before drawing again.")
		return

	var data: Dictionary = draw_cards[draw_index % draw_cards.size()]
	draw_index += 1

	var card: Node2D = create_card(data)
	card.position = deck_position
	card.rotation_degrees = -8
	add_child(card)
	hand_cards.append(card)

	arrange_hand(0.38, false)

	has_drawn = true
	set_message("You drew a wild." if data["wild"] else "You drew a card.")

func discard_selected_card():
	if selected_card == null:
		set_message("Pick a card first, honey.")
		return

	if not has_drawn:
		set_message("Draw first, honey.")
		return

	var card: Node2D = selected_card
	selected_card = null
	hand_cards.erase(card)

	if card.has_method("force_deselect"):
		card.force_deselect()

	if card.has_method("set_interactable"):
		card.set_interactable(false)

	card.remove_from_group("hand_cards")
	card.z_index = 20 + discard_count

	var settle_offset: Vector2 = Vector2((discard_count % 3) * 2, (discard_count % 2) * 2)
	var settle_rotation: float = -4.0 + float((discard_count % 5) * 2)
	discard_count += 1

	if card.has_method("fly_to"):
		card.fly_to(discard_position + settle_offset, settle_rotation, 0.36)
	else:
		var fallback_tween: Tween = create_tween()
		fallback_tween.tween_property(card, "position", discard_position + settle_offset, 0.36)
		fallback_tween.parallel().tween_property(card, "rotation_degrees", settle_rotation, 0.36)

	var tween: Tween = create_tween()
	tween.tween_interval(0.36)
	tween.tween_callback(func():
		if card.is_wild:
			set_message("...Honey. You discarded a wild.")
		else:
			set_message("Card discarded. Grace is thinking.")

		has_drawn = false
		arrange_hand(0.28, false)
	)

func arrange_hand(duration: float = 0.28, stagger: bool = false):
	var count: int = hand_cards.size()

	if count == 0:
		return

	var spacing: float = 80.0
	if count > 4:
		spacing = 64.0

	var total_width: float = spacing * float(count - 1)
	var start_x: float = hand_position.x - (total_width / 2.0)
	var center_index: float = float(count - 1) / 2.0

	for i: int in range(count):
		var card: Node2D = hand_cards[i]
		var card_index: float = float(i)
		var curve_offset: float = abs(card_index - center_index) * 6.0
		var target: Vector2 = Vector2(start_x + (card_index * spacing), hand_position.y + curve_offset)
		var rotation: float = (card_index - center_index) * 7.0
		var delay: float = 0.08 * card_index if stagger else 0.0

		card.z_index = 10 + i

		if card.has_method("move_to"):
			card.move_to(target, rotation, duration, delay)
		else:
			var tween: Tween = create_tween()
			tween.tween_property(card, "position", target, duration).set_delay(delay)
			tween.parallel().tween_property(card, "rotation_degrees", rotation, duration).set_delay(delay)

func create_card(data: Dictionary) -> Node2D:
	var card: Node2D = CardScene.instantiate()
	card.configure(data)
	card.add_to_group("hand_cards")
	card.selected.connect(on_card_selected)
	card.deselected.connect(on_card_deselected)
	return card

func on_card_selected(card: Node2D):
	if selected_card != null and selected_card != card:
		selected_card.deselect()

	selected_card = card
	set_message("Selected card.")

func on_card_deselected(card: Node2D):
	if selected_card == card:
		selected_card = null
		set_message("Card deselected.")

func add_label(text_value: String, pos: Vector2, color: Color, size: int) -> Label:
	var label: Label = Label.new()
	label.text = text_value
	label.position = pos
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
	return label