extends Node2D

@onready var shooter = $Launcher/Shooter

var points : float = 0
var active_balls : int = 0
var max_balls : int = 1

func too_many_balls():
	return active_balls >= max_balls

func ball_died(ball : Ball):
	var to_add = ball.get_total_points()
	points += to_add
	print("Added: ", to_add)
	%PointCounter.text = str(points)
	active_balls -= 1
	
	if not too_many_balls():
		shooter.active = true

func ball_spawned(ball : Ball):
	ball.connect("dead", ball_died)
	active_balls += 1
	
	if too_many_balls():
		shooter.active = false

func _ready():
	shooter.connect("spawned", ball_spawned)
