extends Area2D

signal selected(card)
signal deselected(card)

var card_id := ""
var rank := ""
var suit := ""
var is_wild := false
var is_face_down := false
var is_selected := false

var original_position := Vector2.ZERO

var background: ColorRect
var rank_label: Label
var suit_label: Label
var wild_label: Label
var collision: CollisionShape2D

func _ready():
	input_pickable = true

	background = ColorRect.new()
	background.size = Vector2(72, 104)
	background.color = Color.WHITE
	add_child(background)

	rank_label = Label.new()
	rank_label.position = Vector2(8, 8)
	rank_label.add_theme_font_size_override("font_size", 18)
	add_child(rank_label)

	suit_label = Label.new()
	suit_label.position = Vector2(22, 34)
	suit_label.add_theme_font_size_override("font_size", 32)
	add_child(suit_label)

	wild_label = Label.new()
	wild_label.position = Vector2(10, 78)
	wild_label.add_theme_font_size_override("font_size", 12)
	add_child(wild_label)

	collision = CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(72, 104)
	collision.shape = shape
	collision.position = Vector2(36, 52)
	add_child(collision)

	update_visual()

func configure(data):
	card_id = data.get("id", "")
	rank = data.get("rank", "")
	suit = data.get("suit", "")
	is_wild = data.get("wild", false)
	is_face_down = data.get("face_down", false)

	update_visual()

func set_card_face(new_rank: String, new_suit: String, wild: bool = false):
	card_id = "%s%s" % [new_rank, new_suit]
	rank = new_rank
	suit = new_suit
	is_wild = wild
	is_face_down = false

	update_visual()

func set_card_back():
	is_face_down = true
	update_visual()

func update_visual():
	if background == null:
		return

	if is_face_down:
		background.color = Color("#6B3F24")
		rank_label.text = ""
		suit_label.text = "◆"
		suit_label.add_theme_color_override("font_color", Color("#F4E7D3"))
		wild_label.text = ""
		return

	background.color = Color("#FFFDF7")
	rank_label.text = rank
	suit_label.text = suit

	var suit_color := Color("#B21E35") if suit in ["♥", "♦"] else Color("#1E1A18")

	rank_label.add_theme_color_override("font_color", suit_color)
	suit_label.add_theme_color_override("font_color", suit_color)

	if is_wild:
		wild_label.text = "WILD"
		wild_label.add_theme_color_override("font_color", Color("#D8A441"))
	else:
		wild_label.text = ""

func select():
	if is_selected:
		return

	is_selected = true
	original_position = position
	position.y -= 22

	selected.emit(self)

func deselect():
	if not is_selected:
		return

	is_selected = false
	position = original_position

	deselected.emit(self)

func force_deselect():
	is_selected = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if is_selected:
			deselect()
		else:
			select()
