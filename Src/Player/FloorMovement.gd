class_name FloorMovement
extends Node

signal floor_move(delta_move)

func _physics_process(delta):
	emit_signal("floor_move", owner.get_floor_velocity())
