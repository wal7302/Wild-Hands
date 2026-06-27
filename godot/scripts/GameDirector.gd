extends Node2D

const CardVisual = preload("res://scripts/CardVisual.gd")

var cranberry := Color("#7A1E2C")
var cream := Color("#F4E7D3")
var walnut := Color("#6B3F24")
var gold := Color("#D8A441")

func _ready():
	draw_background()
	draw_title()
	draw_table()
	draw_deck()
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
	you.position = Vector2(175, 585)
	you.add_theme_font_size_override("font_size", 24)
	you.add_theme_color_override("font_color", gold)
	add_child(you)

func draw_deck():
	var deck = CardVisual.new()
	deck.position = Vector2(165, 350)
	deck.set_card_back()
	add_child(deck)

func deal_cards():
	var positions = [
		Vector2(115, 520),
		Vector2(165, 535),
		Vector2(215, 520)
	]

	for i in range(3):
		var card = CardVisual.new()
		card.position = Vector2(165, 350)
		card.set_card_face(["3", "7", "K"][i], ["♥", "♣", "♦"][i], i == 0)
		add_child(card)

		var tween := create_tween()
		tween.tween_property(card, "position", positions[i], 0.45).set_delay(i * 0.25)
		tween.parallel().tween_property(card, "rotation_degrees", [-10, 0, 10][i], 0.45).set_delay(i * 0.25)
