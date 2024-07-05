extends StaticBody2D

@onready var player = $AnimationPlayer
@onready var sprite = $Sprite
@onready var occluder = $LightOccluder2D

var dying = false

var color : Color
var hit_color : Color
var points : int = 100
var extra_multiplier : float = 0.1

func hit():
	if dying:
		return [ 0, 0 ]
		
	dying = true
	
	var light_tween = get_tree().create_tween()
	light_tween.tween_property(self, "modulate", hit_color, 0.3)
	
	var hit_tween = get_tree().create_tween()
	hit_tween.tween_property(sprite, "scale", Vector2(2,2), 0.1)
	hit_tween.tween_property(sprite, "scale", Vector2(1.0,1.0), 0.1)
	hit_tween.tween_interval(2.0)
	hit_tween.tween_property(sprite, "scale", Vector2(0.0,0.0), 0.1)
	hit_tween.tween_callback(self.queue_free)
	
	var hit_tween2 = get_tree().create_tween()
	hit_tween2.tween_property(occluder, "scale", Vector2(2,2), 0.1)
	hit_tween2.tween_property(occluder, "scale", Vector2(1.0,1.0), 0.1)
	hit_tween2.tween_interval(2.0)
	hit_tween2.tween_property(occluder, "scale", Vector2(0.0,0.0), 0.1)
	
	return [ points, extra_multiplier ]
	
func _ready():
	color = modulate
	hit_color = color.lightened(0.75)

