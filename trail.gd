extends Line2D

var tracking : Node2D
var reparented : bool = false
var fading : bool = false
var track_interval : int = 1
var track_current : int = 0

func reposition():
	tracking.remove_child(self)
	tracking.get_parent().get_parent().get_node("Trails").add_child(self)
	reparented = true

func _ready():
	tracking = get_parent()
	if tracking.ghost == true:
		queue_free()
	else:
		reposition.call_deferred()

func _process(_delta):
	if not reparented:
		return
		
	if tracking == null:
		queue_free()
		return
	
	if not fading and tracking.offscreen:
		fading = true
		var fade = FadeOut.new(1.0)
		add_child(fade)
		print("fading")

	track_current += 1
	
	if track_current >= track_interval:
		add_point(tracking.global_position)
		track_current = 0
