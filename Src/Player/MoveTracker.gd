class_name MoveTracker
extends Spatial

onready var state = get_node("../PlayerState")

signal moved(delta, delta_move)

func _physics_process(delta):
	var delta_move = state.get_velocity() * delta
	emit_signal("moved", delta, delta_move)
