extends Node2D

const CardVisual = preload("res://scripts/CardVisual.gd")
const PlayerHand = preload("res://scripts/PlayerHand.gd")
const DiscardPile = preload("res://scripts/DiscardPile.gd")
const GameAudio = preload("res://scripts/GameAudio.gd")
const GraceReaction = preload("res://scripts/GraceReaction.gd")

var cranberry := Color("#7A1E2C")
var cream := Color("#F4E7D3")
var walnut := Color("#6B3F24")
var gold := Color("#D8A441")

var deck_position := Vector2(165, 350)
var player_hand: PlayerHand
var discard_pile: DiscardPile
var message_label: Label
var audio: GameAudio
var grace_reaction: GraceReaction

var current_turn := "player"
var round_number := 1
var max_rounds := 3
var player_discards_this_round := 0

func _ready():
	audio = GameAudio.new()
	add_child(audio)

	draw_background()
	draw_title()
	draw_table()
	draw_deck()
	create_discard_pile()
	create_player_hand()
	create_grace_reaction()
	create_buttons()
	deal_cards()

func draw_background():
	var bg := ColorRect.new()
	bg.color = cream
	bg.size = get_viewport_rect().size
	add_child(bg)

func draw_title():
	var title := Label.new()
	title.text = "Wild Hands"
	title.position = Vector2(82, 50)
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", cranberry)
	add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Friday Night at Grace's"
	subtitle.position = Vector2(105, 100)
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", Color("#2E1B12"))
	add_child(subtitle)

func draw_table():
	var table := Polygon2D.new()
	table.color = walnut
	table.polygon = PackedVector2Array([
		Vector2(70, 210),
		Vector2(320, 210),
		Vector2(360, 380),
		Vector2(320, 620),
		Vector2(70, 620),
		Vector2(30, 380)
	])
	add_child(table)

	var label := Label.new()
	label.text = "Grace"
	label.position = Vector2(165, 230)
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", gold)
	add_child(label)

	var you := Label.new()
	you.text = "You"
	you.position = Vector2(175, 590)
	you.add_theme_font_size_override("font_size", 24)
	you.add_theme_color_override("font_color", gold)
	add_child(you)

	var wild := Label.new()
	wild.text = "3s are wild"
	wild.position = Vector2(135, 430)
	wild.add_theme_font_size_override("font_size", 22)
	wild.add_theme_color_override("font_color", cream)
	add_child(wild)

	message_label = Label.new()
	message_label.text = "Grace deals one card at a time."
	message_label.position = Vector2(52, 650)
	message_label.size = Vector2(300, 60)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.add_theme_font_size_override("font_size", 18)
	message_label.add_theme_color_override("font_color", cranberry)
	add_child(message_label)

func draw_deck():
	var deck = CardVisual.new()
	deck.position = deck_position
	deck.set_card_back()
	add_child(deck)

func create_discard_pile():
	discard_pile = DiscardPile.new()
	discard_pile.position = Vector2(235, 350)
	add_child(discard_pile)

func create_player_hand():
	player_hand = PlayerHand.new()
	player_hand.position = Vector2(195, 535)
	add_child(player_hand)

func create_grace_reaction():
	grace_reaction = GraceReaction.new()
	grace_reaction.position = Vector2(195, 185)
	add_child(grace_reaction)

func create_buttons():
	var discard_button := Button.new()
	discard_button.text = "Discard"
	discard_button.position = Vector2(145, 725)
	discard_button.size = Vector2(110, 46)
	discard_button.pressed.connect(discard_selected_card)
	add_child(discard_button)

func deal_cards():
	var faces = [
		{"rank": "3", "suit": "♥", "wild": true},
		{"rank": "7", "suit": "♣", "wild": false},
		{"rank": "K", "suit": "♦", "wild": false}
	]

	for i in range(faces.size()):
		var card = CardVisual.new()
		card.position = deck_position
		card.set_card_face(faces[i]["rank"], faces[i]["suit"], faces[i]["wild"])
		add_child(card)

		var tween := create_tween()
		tween.tween_property(card, "position", player_hand.global_position, 0.45).set_delay(i * 0.25)
		tween.tween_callback(func():
			audio.play_card_deal()
			card.get_parent().remove_child(card)
			player_hand.add_card(card)
		).set_delay(i * 0.25 + 0.45)

func discard_selected_card():
    if current_turn != "player":
		message_label.text = "Wait your turn."
		return

	if player_hand.selected_card == null:
		message_label.text = "Pick a card first, honey."
		grace_reaction.say("Pick a card first, honey.")
		return

	var card = player_hand.selected_card
	player_hand.remove_card(card)
	card.get_parent().remove_child(card)
	add_child(card)
	card.global_position = player_hand.global_position

	var target := discard_pile.global_position

	var tween := create_tween()
	tween.tween_property(card, "global_position", target, 0.35)
	tween.tween_callback(func():
		card.get_parent().remove_child(card)
		discard_pile.place_card(card)

		if card.is_wild:
			audio.play_wild_discard()
			message_label.text = "...Honey. You discarded a wild."
			grace_reaction.say("...Honey.")
		else:
			audio.play_card_discard()
			message_label.text = "Card discarded."

		player_discards_this_round += 1
		current_turn = "grace"
		message_label.text += " Grace is thinking..."
		grace_take_turn()

func grace_take_turn():
	await get_tree().create_timer(1.0).timeout

	message_label.text = "Grace discards."
	grace_reaction.say("Your move.")

	current_turn = "player"

	)
