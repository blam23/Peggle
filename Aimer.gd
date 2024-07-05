extends Node2D

@export var shooter : Shooter
@export var max_collisions_shown : int = 2

@onready var ball = $Ghost
@onready var line = $Line

var gravity : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity") * ProjectSettings.get_setting("physics/2d/default_gravity_vector")

var max_steps : int = 20
var step_delta : float = 0.01666666666667

var positions : PackedVector2Array = PackedVector2Array()

func predict_line():
	line.clear_points()
	positions.clear()

	if not shooter.active:
		return

	ball.position = Vector2.ZERO
	ball.velocity = shooter.get_ball_launch_velocity()
	var collisions = 0

	for step in range(0, max_steps):
		var collide = ball.move(step_delta)
		line.add_point(ball.position)
		if collide:
			positions.push_back(ball.position)
			collisions += 1
			if collisions >= max_collisions_shown:
				break

func _draw():
	if not shooter.active:
		return

	for pos in positions:
		draw_circle(pos, 8, Color.CYAN)

func _process(_delta):
	predict_line()
	queue_redraw()
