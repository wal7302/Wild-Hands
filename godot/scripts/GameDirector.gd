extends Node2D

const CardVisual = preload("res://scripts/CardVisual.gd")
const PlayerHand = preload("res://scripts/PlayerHand.gd")
const DiscardPile = preload("res://scripts/DiscardPile.gd")
const GameAudio = preload("res://scripts/GameAudio.gd")
const GraceReaction = preload("res://scripts/GraceReaction.gd")
const EngineBridge = preload("res://scripts/EngineBridge.gd")

var cranberry := Color("#7A1E2C")
var cream := Color("#F4E7D3")
var walnut := Color("#6B3F24")
var gold := Color("#D8A441")

var deck_position := Vector2(165, 350)
var grace_card_position := Vector2(165, 270)

var engine
var player_hand: PlayerHand
var discard_pile: DiscardPile
var message_label: Label
var round_label: Label
var score_label: Label
var audio: GameAudio
var grace_reaction: GraceReaction

var current_turn := "player"
var player_has_drawn := false
var round_number := 1
var hand_size := 3
var player_score := 0
var grace_score := 0
var round_active := true

func _ready():
	engine = EngineBridge.new()
	add_child(engine)

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
	start_round()

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

	var grace := Label.new()
	grace.text = "Grace"
	grace.position = Vector2(165, 230)
	grace.add_theme_font_size_override("font_size", 24)
	grace.add_theme_color_override("font_color", gold)
	add_child(grace)

	var you := Label.new()
	you.text = "You"
	you.position = Vector2(175, 590)
	you.add_theme_font_size_override("font_size", 24)
	you.add_theme_color_override("font_color", gold)
	add_child(you)

	round_label = Label.new()
	round_label.position = Vector2(130, 420)
	round_label.add_theme_font_size_override("font_size", 22)
	round_label.add_theme_color_override("font_color", cream)
	add_child(round_label)

	score_label = Label.new()
	score_label.position = Vector2(80, 128)
	score_label.size = Vector2(260, 40)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.add_theme_font_size_override("font_size", 16)
	score_label.add_theme_color_override("font_color", cranberry)
	add_child(score_label)

	message_label = Label.new()
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
	var draw_button := Button.new()
	draw_button.text = "Draw"
	draw_button.position = Vector2(38, 725)
	draw_button.size = Vector2(86, 46)
	draw_button.pressed.connect(draw_card)
	add_child(draw_button)

	var discard_button := Button.new()
	discard_button.text = "Discard"
	discard_button.position = Vector2(146, 725)
	discard_button.size = Vector2(98, 46)
	discard_button.pressed.connect(discard_selected_card)
	add_child(discard_button)

	var go_out_button := Button.new()
	go_out_button.text = "Go Out"
	go_out_button.position = Vector2(266, 725)
	go_out_button.size = Vector2(88, 46)
	go_out_button.pressed.connect(go_out)
	add_child(go_out_button)

func start_round():
	round_active = true
	current_turn = "player"
	player_has_drawn = false
	hand_size = round_number + 2
	round_label.text = "Round %s • %ss wild" % [round_number, hand_size]
	score_label.text = "You: %s   Grace: %s" % [player_score, grace_score]
	message_label.text = "Grace deals one card at a time."
	clear_player_hand()
	deal_cards()

func clear_player_hand():
	for card in player_hand.cards:
		card.queue_free()

	player_hand.cards.clear()
	player_hand.selected_card = null
	player_hand.arrange_cards()

func deal_cards():
	for i in range(hand_size):
		var card_data = engine.draw_card()

		if card_data == null:
			message_label.text = "Deck is empty."
			return

		var card = CardVisual.new()
		card.position = deck_position
		card.set_card_face(card_data["rank"], card_data["suit"], card_data["wild"])
		add_child(card)

		var tween := create_tween()
		tween.tween_property(card, "position", player_hand.global_position, 0.45).set_delay(i * 0.18)
		tween.tween_callback(func():
			audio.play_card_deal()
			card.get_parent().remove_child(card)
			player_hand.add_card(card)
		).set_delay(i * 0.18 + 0.45)

func draw_card():
	if not round_active:
		message_label.text = "Start the next round, honey."
		return

	if current_turn != "player":
		message_label.text = "Wait your turn."
		return

	if player_has_drawn:
		message_label.text = "Discard before drawing again."
		return

	var card_data = engine.draw_card()

	if card_data == null:
		message_label.text = "Deck is empty."
		return

	var card = CardVisual.new()
	card.position = deck_position
	card.set_card_face(card_data["rank"], card_data["suit"], card_data["wild"])
	add_child(card)

	var tween := create_tween()
	tween.tween_property(card, "position", player_hand.global_position, 0.35)
	tween.tween_callback(func():
		audio.play_card_deal()
		card.get_parent().remove_child(card)
		player_hand.add_card(card)
		player_has_drawn = true
		message_label.text = "You drew a wild." if card.is_wild else "You drew a card."
	)

func discard_selected_card():
	if not round_active:
		message_label.text = "Round is over."
		return

	if current_turn != "player":
		message_label.text = "Wait your turn."
		return

	if not player_has_drawn:
		message_label.text = "Draw first, honey."
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
			message_label.text = "...Honey. You discarded a wild. Grace is thinking..."
			grace_reaction.say("...Honey.")
		else:
			audio.play_card_discard()
			message_label.text = "Card discarded. Grace is thinking."

		current_turn = "grace"
		player_has_drawn = false
		grace_take_turn()
	)

func grace_take_turn():
	await get_tree().create_timer(1.0).timeout

	if not round_active:
		return

	var grace_card = CardVisual.new()
	grace_card.position = deck_position
	grace_card.set_card_back()
	add_child(grace_card)

	var tween := create_tween()
	tween.tween_property(grace_card, "position", grace_card_position, 0.35)
	tween.tween_callback(func():
		audio.play_card_deal()
		message_label.text = "Grace draws."
	)

	await get_tree().create_timer(0.8).timeout

	var discard_card = CardVisual.new()
	discard_card.position = grace_card_position
	discard_card.set_card_face("9", "♣", false)
	add_child(discard_card)

	grace_card.queue_free()

	var discard_tween := create_tween()
	discard_tween.tween_property(discard_card, "global_position", discard_pile.global_position, 0.35)
	discard_tween.tween_callback(func():
		audio.play_card_discard()
		discard_card.get_parent().remove_child(discard_card)
		discard_pile.place_card(discard_card)
		message_label.text = "Grace discarded. Your move."
		grace_reaction.say("Your move.")
		current_turn = "player"
	)

func go_out():
	if not round_active:
		next_round()
		return

	if current_turn != "player":
		message_label.text = "Wait your turn."
		return

	round_active = false

	var round_points: int = calculate_hand_points()
	player_score += round_points
	grace_score += 12

	score_label.text = "You: %s   Grace: %s" % [player_score, grace_score]
	message_label.text = "You went out! Round score: %s" % round_points
	grace_reaction.say("Now that was a hand.")

	await get_tree().create_timer(1.5).timeout
	message_label.text = "Tap Go Out to start next round."

func next_round():
	if round_number >= 3:
		var winner := "You" if player_score <= grace_score else "Grace"
		message_label.text = "Match complete. Winner: %s" % winner
		grace_reaction.say("Good game, honey.")
		return

	round_number += 1
	start_round()

func calculate_hand_points():
	var total := 0

	for card in player_hand.cards:
		if not card.is_wild:
			total += card_point_value(card.rank)

	return total

func card_point_value(rank):
	if rank == "A":
		return 13
	if rank == "K":
		return 12
	if rank == "Q":
		return 11
	if rank == "J":
		return 10

	return int(rank)
