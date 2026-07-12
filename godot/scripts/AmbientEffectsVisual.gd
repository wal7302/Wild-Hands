class_name AmbientEffectsVisual
extends Node2D

const SCREEN_SIZE := Vector2(390, 844)
const DUST_COUNT := 18

var dust_particles: Array[Dictionary] = []
var elapsed_time := 0.0

func _ready():
	z_index = 90
	mouse_filter_ignore()
	create_dust_particles()
	queue_redraw()

func _process(delta: float):
	elapsed_time += delta

	for particle: Dictionary in dust_particles:
		var position: Vector2 = particle["position"]
		var speed: float = particle["speed"]
		var drift: float = particle["drift"]

		position.y -= speed * delta
		position.x += sin(
			elapsed_time * drift + particle["phase"]
		) * delta * 2.5

		if position.y < 170.0:
			position.y = 690.0
			position.x = randf_range(35.0, 355.0)

		particle["position"] = position

	queue_redraw()

func mouse_filter_ignore():
	process_mode = Node.PROCESS_MODE_ALWAYS

func create_dust_particles():
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	for i: int in range(DUST_COUNT):
		dust_particles.append({
			"position": Vector2(
				rng.randf_range(30.0, 360.0),
				rng.randf_range(180.0, 690.0)
			),
			"radius": rng.randf_range(0.7, 1.8),
			"alpha": rng.randf_range(0.05, 0.16),
			"speed": rng.randf_range(2.0, 7.0),
			"drift": rng.randf_range(0.5, 1.4),
			"phase": rng.randf_range(0.0, TAU)
		})

func _draw():
	draw_warm_table_glow()
	draw_dust_particles()
	draw_vignette()

func draw_warm_table_glow():
	var center := Vector2(
		195.0 + sin(elapsed_time * 0.18) * 4.0,
		405.0
	)

	for i: int in range(8, 0, -1):
		var radius: float = float(i) * 38.0
		var alpha: float = float(9 - i) * 0.006

		draw_circle(
			center,
			radius,
			Color(1.0, 0.72, 0.32, alpha)
		)

func draw_dust_particles():
	for particle: Dictionary in dust_particles:
		draw_circle(
			particle["position"],
			particle["radius"],
			Color(
				1.0,
				0.87,
				0.62,
				particle["alpha"]
			)
		)

func draw_vignette():
	for i: int in range(8):
		var inset: float = float(i) * 4.0
		var alpha: float = 0.018 + float(i) * 0.006

		draw_rect(
			Rect2(
				Vector2(inset, inset),
				SCREEN_SIZE - Vector2(inset * 2.0, inset * 2.0)
			),
			Color(0.10, 0.035, 0.015, alpha),
			false,
			8.0
		)