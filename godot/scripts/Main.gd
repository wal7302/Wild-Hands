extends Node

const MainMenuScene := preload("res://scenes/MainMenu.tscn")
const GameSetupScene := preload("res://scenes/GameSetup.tscn")
const GameTableScript := preload("res://scripts/GameTable.gd")

var active_screen: Node = null
var selected_game_settings: Dictionary = {}

func _ready():
	show_main_menu()

func clear_active_screen():
	if active_screen == null:
		return

	if is_instance_valid(active_screen):
		remove_child(active_screen)
		active_screen.queue_free()

	active_screen = null

func show_main_menu():
	clear_active_screen()

	var main_menu: Control = MainMenuScene.instantiate()
	main_menu.play_requested.connect(show_game_setup)

	active_screen = main_menu
	add_child(main_menu)

func show_game_setup():
	clear_active_screen()

	var game_setup: Control = GameSetupScene.instantiate()
	game_setup.back_requested.connect(show_main_menu)
	game_setup.start_game_requested.connect(start_game)

	active_screen = game_setup
	add_child(game_setup)

func start_game(settings: Dictionary):
	selected_game_settings = settings.duplicate(true)

	clear_active_screen()

	var game_table := Node2D.new()
	game_table.name = "GameTable"
	game_table.set_script(GameTableScript)
	game_table.set_meta(
		"game_settings",
		selected_game_settings
	)

	active_screen = game_table
	add_child(game_table)
