class_name Ball extends CharacterBody2D

@export var ghost : bool = false

@onready var hit_sound = $HitSound

var gravity : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity") * ProjectSettings.get_setting("physics/2d/default_gravity_vector")
var screen_size : Vector2 = DisplayServer.window_get_size()
var bounce_speed_multiplier : float = 1.0
var air_drag_multiplier : float = 0.99
var hit_sound_pitch : float

var multiplier : float = 1
var total_points : float = 0
var dying : bool = false
var offscreen : bool = false

signal gained_points(ball : Ball, data : Dictionary)
signal about_to_die(ball : Ball)
signal dead(ball : Ball)

func reset_bong():
	hit_sound_pitch = 0.9

func bong():
	hit_sound_pitch *= 1.05
	hit_sound_pitch = min(3.0, hit_sound_pitch)
	hit_sound.pitch_scale = hit_sound_pitch
	hit_sound.play()

func _ready():
	reset_bong()

func move(delta):
	var collided = false
	velocity += gravity * delta
	if check_hit(delta): collided = true
	if check_bounds(): collided = true
	
	velocity *= air_drag_multiplier
	
	return collided

func check_hit(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		velocity *= bounce_speed_multiplier
		if not ghost:
			if collision.get_collider().has_method("hit"):
				var res = collision.get_collider().hit()
				var points = res[0]
				var mult = res[1]
				if points > 0:
					bong()
					var data = { 
						points = points,
						multiplier = mult,
						result = points
					}
					gained_points.emit(self, data)
					multiplier += data["multiplier"]
					total_points += data["result"]
					print("Points: ", total_points, " - Multiplier: ", multiplier)
		return true
	return false

func check_bounds():
	if global_position.y < 0:
		velocity.y *= -1
		return true
	return false

func _physics_process(delta):
	move(delta)
	
	if not ghost and dying:
		dead.emit(self)
		queue_free()

func no_longer_visible():
	if ghost or offscreen:
		return
	
	offscreen = true
	await get_tree().create_timer(1.0).timeout
	
	dying = true
	about_to_die.emit(self)

func get_total_points():
	return total_points * multiplier
