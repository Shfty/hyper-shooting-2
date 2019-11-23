class_name PlayerState
extends Node

var velocity = Vector3.ZERO setget set_velocity, get_velocity
var grounded = true setget set_grounded, get_grounded
var sliding = false setget set_sliding, get_sliding
var diving = false setget set_diving, get_diving

signal velocity_changed(velocity)
signal grounded_changed(grounded)
signal sliding_changed(sliding)
signal diving_changed(diving)

# Setters
func set_velocity(new_velocity):
	if(velocity != new_velocity):
		velocity = new_velocity
		emit_signal("velocity_changed", velocity)

func set_grounded(new_grounded):
	if(grounded != new_grounded):
		grounded = new_grounded
		emit_signal("grounded_changed", grounded)

func set_sliding(new_sliding):
	if(sliding != new_sliding):
		sliding = new_sliding
		emit_signal("sliding_changed", sliding)

func set_diving(new_diving):
	if(diving != new_diving):
		diving = new_diving
		emit_signal("diving_changed", diving)

# Getters
func get_velocity():
	return velocity

func get_grounded():
	return grounded

func get_sliding():
	return sliding

func get_diving():
	return diving
