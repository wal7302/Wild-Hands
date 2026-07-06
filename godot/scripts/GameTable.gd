extends Node2D

var cranberry := Color("#7A1E2C")
var cream := Color("#F4E7D3")
var room_gold := Color("#F7E0BD")
var walnut := Color("#6B3F24")
var walnut_dark := Color("#3B2114")
var gold := Color("#D8A441")
var card_white := Color("#FFFDF7")
var black := Color("#1E1A18")
var red := Color("#B21E35")

var deck_position := Vector2(158, 350)
var discard_position := Vector2(232, 350)
var hand_position := Vector2(195, 610)

var message_label: Label
var hand_cards: Array = []
var selected_card: Node2D = null
var has_drawn := false
var draw_index := 0

var draw_cards := [
	{"rank": "8", "suit": "♥", "wild": false},
	{"rank": "3", "suit": "♠", "wild": true},
	{"rank": "Q", "suit": "♣", "wild": false}
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

	var room: ColorRect = ColorRect.new()
	room.color = room_gold
	room.position = Vector2(18, 145)
	room.size = Vector2(354, 560)
	room.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(room)

func draw_title():
	add_label("Wild Hands", Vector2(78, 42), cranberry, 42)
	add_label("Friday Night at Grace's", Vector2(100, 94), Color("#2E1B12"), 18)

func draw_table():
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

	var rim: Line2D = Line2D.new()
	rim.width = 10
	rim.default_color = walnut_dark
	rim.closed = true
	rim.points = table.polygon
	add_child(rim)

func draw_players():
	add_label("🍷 Grace", Vector2(145, 235), gold, 24)
	add_label("🙂 You", Vector2(160, 665), gold, 24)
	add_label("🔥", Vector2(42, 166), cranberry, 34)
	add_label("🍪", Vector2(312, 166), cranberry, 30)

func draw_deck_and_discard():
	create_card_back(deck_position)
	add_label("Deck", Vector2(deck_position.x + 5, deck_position.y + 88), cream, 14)

	var discard: ColorRect = ColorRect.new()
	discard.color = Color("#E9CFA8")
	discard.position = discard_position
	discard.size = Vector2(58, 82)
	discard.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(discard)

	add_label("Discard", Vector2(discard_position.x - 2, discard_position.y + 88), cream, 14)
	add_label("3s Wild", Vector2(146, 468), cream, 24)

func draw_buttons():
	var draw_button: Button = Button.new()
	draw_button.text = "Draw"
	draw_button.position = Vector2(72, 748)
	draw_button.size = Vector2(100, 52)
	draw_button.pressed.connect(draw_card)
	add_child(draw_button)

	var discard_button: Button = Button.new()
	discard_button.text = "Discard"
	discard_button.position = Vector2(218, 748)
	discard_button.size = Vector2(100, 52)
	discard_button.pressed.connect(discard_selected_card)
	add_child(discard_button)

func draw_message():
	message_label = add_label("Grace deals one card at a time.", Vector2(38, 710), cranberry, 16)
	message_label.size = Vector2(320, 28)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func deal_opening_hand():
	for child: Node in get_tree().get_nodes_in_group("hand_cards"):
		child.queue_free()

	hand_cards.clear()
	selected_card = null
	has_drawn = false

	var cards: Array = [
		{"rank": "3", "suit": "♥", "wild": true},
		{"rank": "7", "suit": "♣", "wild": false},
		{"rank": "K", "suit": "♦", "wild": false}
	]

	for i: int in range(cards.size()):
		var card: Node2D = create_card_face(cards[i])
		card.add_to_group("hand_cards")
		card.position = deck_position
		add_child(card)
		hand_cards.append(card)

		var target: Vector2 = Vector2(hand_position.x - 80 + (i * 80), hand_position.y)
		var tween: Tween = create_tween()
		tween.tween_property(card, "position", target, 0.45).set_delay(i * 0.18)
		tween.parallel().tween_property(card, "rotation_degrees", -8 + (i * 8), 0.45).set_delay(i * 0.18)

func draw_card():
	if has_drawn:
		message_label.text = "Discard before drawing again."
		return

	var data: Dictionary = draw_cards[draw_index % draw_cards.size()]
	draw_index += 1

	var card: Node2D = create_card_face(data)
	card.add_to_group("hand_cards")
	card.position = deck_position
	add_child(card)
	hand_cards.append(card)

	var target: Vector2 = Vector2(hand_position.x - 120 + ((hand_cards.size() - 1) * 80), hand_position.y)

	var tween: Tween = create_tween()
	tween.tween_property(card, "position", target, 0.4)
	tween.parallel().tween_property(card, "rotation_degrees", 10, 0.4)
	tween.tween_callback(func():
		has_drawn = true
		message_label.text = "You drew a wild." if data["wild"] else "You drew a card."
	)

func discard_selected_card():
	if selected_card == null:
		message_label.text = "Pick a card first, honey."
		return

	if not has_drawn:
		message_label.text = "Draw first, honey."
		return

	var card: Node2D = selected_card
	selected_card = null
	hand_cards.erase(card)

	var tween: Tween = create_tween()
	tween.tween_property(card, "position", discard_position, 0.35)
	tween.parallel().tween_property(card, "rotation_degrees", 5, 0.35)
	tween.tween_callback(func():
		if card.has_meta("wild") and card.get_meta("wild") == true:
			message_label.text = "...Honey. You discarded a wild."
		else:
			message_label.text = "Card discarded. Grace is thinking."
		has_drawn = false
		arrange_hand()
	)

func arrange_hand():
	for i: int in range(hand_cards.size()):
		var card: Node2D = hand_cards[i]
		var target: Vector2 = Vector2(hand_position.x - ((hand_cards.size() - 1) * 40) + (i * 80), hand_position.y)
		var tween: Tween = create_tween()
		tween.tween_property(card, "position", target, 0.25)
		tween.parallel().tween_property(card, "rotation_degrees", (i - 1) * 8, 0.25)

func create_card_back(pos: Vector2):
	var card: ColorRect = ColorRect.new()
	card.color = card_white
	card.position = pos
	card.size = Vector2(58, 82)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(card)

	add_label("◆", Vector2(pos.x + 17, pos.y + 20), cranberry, 34)

func create_card_face(data: Dictionary) -> Node2D:
	var node: Area2D = Area2D.new()
	node.input_pickable = true
	node.set_meta("wild", data["wild"])

	var collision: CollisionShape2D = CollisionShape2D.new()
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(64, 92)
	collision.shape = shape
	collision.position = Vector2(32, 46)
	node.add_child(collision)

	node.input_event.connect(func(_viewport, event, _shape_idx):
		if event is InputEventMouseButton and event.pressed:
			select_card(node)
	)

	var bg: ColorRect = ColorRect.new()
	bg.color = card_white
	bg.size = Vector2(64, 92)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(bg)

	var border: Line2D = Line2D.new()
	border.width = 3
	border.default_color = cranberry
	border.closed = true
	border.points = PackedVector2Array([
		Vector2(0, 0),
		Vector2(64, 0),
		Vector2(64, 92),
		Vector2(0, 92)
	])
	node.add_child(border)

	var suit_color: Color = red if data["suit"] in ["♥", "♦"] else black

	var rank: Label = Label.new()
	rank.text = data["rank"]
	rank.position = Vector2(7, 5)
	rank.add_theme_font_size_override("font_size", 20)
	rank.add_theme_color_override("font_color", suit_color)
	rank.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(rank)

	var suit: Label = Label.new()
	suit.text = data["suit"]
	suit.position = Vector2(20, 30)
	suit.add_theme_font_size_override("font_size", 34)
	suit.add_theme_color_override("font_color", suit_color)
	suit.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(suit)

	if data["wild"]:
		var wild: Label = Label.new()
		wild.text = "WILD"
		wild.position = Vector2(12, 68)
		wild.add_theme_font_size_override("font_size", 11)
		wild.add_theme_color_override("font_color", gold)
		wild.mouse_filter = Control.MOUSE_FILTER_IGNORE
		node.add_child(wild)

	return node

func select_card(card: Node2D):
	if selected_card != null and selected_card != card:
		selected_card.position.y += 22

	if selected_card == card:
		selected_card.position.y += 22
		selected_card = null
		message_label.text = "Card deselected."
		return

	selected_card = card
	card.position.y -= 22
	message_label.text = "Selected card."

func add_label(text_value: String, pos: Vector2, color: Color, size: int) -> Label:
	var label: Label = Label.new()
	label.text = text_value
	label.position = pos
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
	return label