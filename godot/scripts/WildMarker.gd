class_name WildMarker
extends Node2D


var cranberry := Color("#7A1E2C")
var cream := Color("#F4E7D3")
var gold := Color("#D8A441")
var walnut_dark := Color("#2B160D")

var background: Panel
var wild_label: Label
var rank_label: Label
var rank_name_label: Label
var audio_player: AudioStreamPlayer

var active_tween: Tween


func _ready():
	build_marker()
	hide_immediately()


func build_marker():
	background = Panel.new()
	background.position = Vector2(-62, -54)
	background.size = Vector2(124, 108)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("#3A1F16")
	panel_style.border_color = gold
	panel_style.set_border_width_all(3)
	panel_style.corner_radius_top_left = 14
	panel_style.corner_radius_top_right = 14
	panel_style.corner_radius_bottom_left = 14
	panel_style.corner_radius_bottom_right = 14

	background.add_theme_stylebox_override(
		"panel",
		panel_style
	)

	add_child(background)

	wild_label = create_centered_label(
		"WILD",
		Vector2(-58, -46),
		Vector2(116, 24),
		gold,
		15
	)

	rank_label = create_centered_label(
		"",
		Vector2(-58, -24),
		Vector2(116, 52),
		cream,
		42
	)

	rank_name_label = create_centered_label(
		"",
		Vector2(-58, 27),
		Vector2(116, 24),
		gold,
		13
	)

	audio_player = AudioStreamPlayer.new()
	audio_player.volume_db = -4.0
	add_child(audio_player)


func create_centered_label(
	text_value: String,
	label_position: Vector2,
	label_size: Vector2,
	font_color: Color,
	font_size: int
) -> Label:
	var label := Label.new()

	label.text = text_value
	label.position = label_position
	label.size = label_size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	label.add_theme_font_size_override(
		"font_size",
		font_size
	)

	label.add_theme_color_override(
		"font_color",
		font_color
	)

	add_child(label)

	return label


func reveal_rank(
	rank: int,
	sound: AudioStream = null
):
	if active_tween != null:
		active_tween.kill()

	visible = true
	modulate = Color.WHITE
	modulate.a = 0.0
	scale = Vector2(0.45, 0.45)

	rank_label.text = rank_symbol(rank)
	rank_name_label.text = (
		rank_display_name(rank).to_upper()
	)

	if sound != null:
		audio_player.stream = sound
		audio_player.play()

	active_tween = create_tween()

	# Fade and pop into view together.
	active_tween.set_parallel(true)

	active_tween.tween_property(
		self,
		"modulate:a",
		1.0,
		0.20
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_OUT
	)

	active_tween.tween_property(
		self,
		"scale",
		Vector2(1.18, 1.18),
		0.28
	).set_trans(
		Tween.TRANS_BACK
	).set_ease(
		Tween.EASE_OUT
	)

	# Everything after this point runs sequentially.
	active_tween.set_parallel(false)

	active_tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.20
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_IN_OUT
	)

	# Keep the reveal fully visible long enough to read.
	active_tween.tween_interval(3.0)

	# Fade away after the hold has completed.
	active_tween.tween_property(
		self,
		"modulate:a",
		0.0,
		0.50
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_IN
	)

	active_tween.tween_callback(
		hide_immediately
	)


func pulse():
	if active_tween != null:
		active_tween.kill()

	active_tween = create_tween()

	active_tween.tween_property(
		self,
		"scale",
		Vector2(1.07, 1.07),
		0.16
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_OUT
	)

	active_tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.20
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_IN_OUT
	)


func hide_immediately():
	visible = false
	modulate = Color.WHITE
	scale = Vector2.ONE


func rank_symbol(rank: int) -> String:
	match rank:
		1:
			return "A"
		11:
			return "J"
		12:
			return "Q"
		13:
			return "K"
		_:
			return str(rank)


func rank_display_name(rank: int) -> String:
	match rank:
		1:
			return "Aces"
		2:
			return "Twos"
		3:
			return "Threes"
		4:
			return "Fours"
		5:
			return "Fives"
		6:
			return "Sixes"
		7:
			return "Sevens"
		8:
			return "Eights"
		9:
			return "Nines"
		10:
			return "Tens"
		11:
			return "Jacks"
		12:
			return "Queens"
		13:
			return "Kings"
		_:
			return "Wild"
