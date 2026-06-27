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

var background : ColorRect
var rank_label : Label
var suit_label : Label
var wild_label : Label

func _ready():

	input_pickable = true

	background = ColorRect.new()
	background.size = Vector2(72,104)
	background.color = Color.WHITE
	add_child(background)

	rank_label = Label.new()
	rank_label.position = Vector2(8,8)
	add_child(rank_label)

	suit_label = Label.new()
	suit_label.position = Vector2(8,32)
	add_child(suit_label)

	wild_label = Label.new()
	wild_label.position = Vector2(8,78)
	wild_label.text = ""
	add_child(wild_label)

func configure(data):

	card_id = data.get("id","")
	rank = data.get("rank","")
	suit = data.get("suit","")
	is_wild = data.get("wild",false)

	update_visual()

func update_visual():

	if is_face_down:

		background.color = Color("#6B3F24")

		rank_label.text = ""

		suit_label.text = ""

		wild_label.text = ""

		return

	background.color = Color.WHITE

	rank_label.text = rank

	suit_label.text = suit

	if is_wild:
		wild_label.text = "WILD"
	else:
		wild_label.text = ""

func set_face_down():

	is_face_down = true
	update_visual()

func set_face_up():

	is_face_down = false
	update_visual()

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

func _input_event(_viewport,event,_shape):

	if event is InputEventMouseButton:

		if event.pressed:

			if is_selected:
				deselect()
			else:
				select()
