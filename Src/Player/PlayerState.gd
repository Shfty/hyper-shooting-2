class_name PlayerState
extends Node

var yaw = 0.0 setget set_yaw, get_yaw
var pitch = 0.0 setget set_pitch, get_pitch

var velocity = Vector3.ZERO setget set_velocity, get_velocity
var grounded = false setget set_grounded, get_grounded

var crouching = false setget set_crouching, get_crouching
var prone = false setget set_prone, get_prone
var prone_basis = 0.0 setget set_prone_basis, get_prone_basis
var prone_direction = Vector3.FORWARD setget set_prone_direction, get_prone_direction

var skating = false setget set_skating, get_skating

var bob = 0.0 setget set_bob, get_bob

signal yaw_changed(yaw)
signal pitch_changed(pitch)

signal velocity_changed(velocity)
signal grounded_changed(grounded)

signal crouching_changed(crouching)
signal prone_changed(prone)
signal prone_basis_changed(prone_basis)
signal prone_direction_changed(prone_direction)

signal skating_changed(skating)

signal bob_changed(bob)

# Setters
func set_yaw(new_yaw):
	if(yaw != new_yaw):
		yaw = new_yaw
		emit_signal("yaw_changed", new_yaw)

func set_pitch(new_pitch):
	if(pitch != new_pitch):
		pitch = new_pitch
		emit_signal("pitch_changed", new_pitch)
		
func set_velocity(new_velocity):
	if(velocity != new_velocity):
		velocity = new_velocity
		emit_signal("velocity_changed", velocity)

func set_grounded(new_grounded):
	if(grounded != new_grounded):
		grounded = new_grounded
		
		emit_signal("grounded_changed", grounded)

func set_crouching(new_crouching):
	if(crouching != new_crouching):
		crouching = new_crouching
		emit_signal("crouching_changed", crouching)

func set_prone(new_prone):
	if(prone != new_prone):
		prone = new_prone
		emit_signal("prone_changed", prone)
		reset_prone_basis()

func set_prone_basis(new_prone_basis):
	if(prone_basis != new_prone_basis):
		prone_basis = new_prone_basis
		emit_signal("prone_basis_changed", prone_basis)

func set_prone_direction(new_prone_direction):
	if(prone_direction != new_prone_direction):
		prone_direction = new_prone_direction
		emit_signal("prone_direction_changed", prone_direction)

func set_skating(new_skating):
	if(skating != new_skating):
		skating = new_skating
		emit_signal("skating_changed", skating)

func set_bob(new_bob):
	if(bob != new_bob):
		bob = new_bob
		emit_signal("bob_changed", bob)

# Getters
func get_yaw():
	return yaw

func get_pitch():
	return pitch

func get_velocity():
	return velocity

func get_grounded():
	return grounded

func get_crouching():
	return crouching

func get_prone():
	return prone

func get_prone_basis():
	return prone_basis

func get_prone_direction():
	return prone_direction

func get_skating():
	return grounded && skating

func get_bob():
	return bob

# Derived
func is_front_prone():
	return Vector3.FORWARD.rotated(Vector3.UP, prone_basis).dot(prone_direction) > 0.5
	
func is_back_prone():
	return Vector3.FORWARD.rotated(Vector3.UP, prone_basis).dot(prone_direction) < 0.5

# Utility
func reset_prone_basis():
	set_prone_basis(rad2deg(get_yaw()))

func add_yaw(delta):
	var yawSign = 1 if abs(get_pitch()) >= PI * 0.5 else -1
	set_yaw(get_yaw() + delta * yawSign)

func add_pitch(delta):
	set_pitch(get_pitch() + delta)
