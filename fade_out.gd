class_name FadeOut extends Node

@export var time : float = 0.5

var m_node : Node2D
var m_current : float

func _init(fadeTime : float):
	time = fadeTime

func _ready():
	m_node = get_parent()

func _physics_process(delta):
	m_current += delta

	m_node.modulate.a = 1 - (m_current / time)

	if(m_current > time):
		m_node.queue_free()
