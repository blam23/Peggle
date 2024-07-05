class_name Shooter extends Sprite2D

@export var min_rotation : float = -1.3
@export var max_rotation : float = 1.5
@export var launch_speed : float = 1000.0

var ball_prefab : Resource
var active : bool = true

signal spawned(ball : Ball)

func _ready():
	ball_prefab = load("res://ball.tscn")

func _process(_delta):
	var new_rot = global_position.angle_to_point(get_global_mouse_position()) - (PI/2)
	var new_rot_clamped = clamp(new_rot, min_rotation, max_rotation)
	if new_rot == new_rot_clamped:
		rotation = new_rot

func get_ball_launch_velocity():
	return Vector2.DOWN.rotated(rotation) * launch_speed

func _input(event):
	if active and event.is_action_pressed("fire_ball"):
		var ball = ball_prefab.instantiate()
		%Balls.add_child(ball)
		ball.global_position = global_position
		ball.velocity = get_ball_launch_velocity()
		spawned.emit(ball)
