extends Node

var camera_rotation = Vector3.ZERO setget set_camera_rotation, get_camera_rotation
var velocity = Vector3.ZERO setget set_velocity, get_velocity
var wants_jump: bool = false setget set_wants_jump, get_wants_jump
var grounded: bool = true setget set_grounded, get_grounded
var crouching: bool = false setget set_crouching, get_crouching
var skating: bool = false setget set_skating, get_skating

signal grounded_changed(grounded)
signal skating_changed(skating)

func get_camera_rotation():
	return camera_rotation

func set_camera_rotation(new_camera_rotation):
	camera_rotation = new_camera_rotation

func get_velocity():
	return velocity

func set_velocity(new_velocity):
	velocity = new_velocity

func get_wants_jump():
	return wants_jump

func set_wants_jump(new_wants_jump):
	wants_jump = new_wants_jump

func get_crouching():
	return crouching

func set_crouching(new_crouching):
	crouching = new_crouching

func get_skating():
	return skating

func set_skating(new_skating):
	if(skating != new_skating):
		skating = new_skating
		emit_signal("skating_changed", skating)
	
func get_grounded():
	return grounded

func set_grounded(new_grounded):
	if(grounded != new_grounded):
		grounded = new_grounded
		emit_signal("grounded_changed", grounded)