class_name PlayerState
extends Node

enum Stance {
	UPRIGHT,
	PRONE
}

var yaw = 0.0 setget set_yaw, get_yaw
var pitch = 0.0 setget set_pitch, get_pitch

var velocity = Vector3.ZERO setget set_velocity, get_velocity
var grounded = false setget set_grounded, get_grounded

var stance = Stance.UPRIGHT setget set_stance, get_stance
var prone_direction = Vector3.FORWARD setget set_prone_direction, get_prone_direction
var prone_basis = Vector3.FORWARD

var skating = false setget set_skating, get_skating

var bob = 0.0 setget set_bob, get_bob

signal yaw_changed(yaw)
signal pitch_changed(pitch)

signal velocity_changed(velocity)
signal grounded_changed(grounded)

signal stance_changed(stance)
signal prone_direction_changed(prone_direction)

signal skating_changed(skating)

signal bob_changed(bob)

# Setters
func set_yaw(new_yaw) -> void:
	if(yaw != new_yaw):
		yaw = new_yaw
		emit_signal("yaw_changed", new_yaw)

func set_pitch(new_pitch) -> void:
	if(pitch != new_pitch):
		pitch = new_pitch
		emit_signal("pitch_changed", new_pitch)

func set_velocity(new_velocity) -> void:
	if(velocity != new_velocity):
		velocity = new_velocity
		emit_signal("velocity_changed", velocity)

func set_grounded(new_grounded) -> void:
	if(grounded != new_grounded):
		grounded = new_grounded

		emit_signal("grounded_changed", grounded)

func set_stance(new_stance) -> void:
	if(stance != new_stance):
		stance = new_stance
		emit_signal("stance_changed", stance)

func set_prone_direction(new_prone_direction) -> void:
	if(prone_direction != new_prone_direction):
		prone_direction = new_prone_direction
		prone_basis = Vector3.FORWARD.rotated(Vector3.UP, yaw)
		emit_signal("prone_direction_changed", prone_direction)

func set_skating(new_skating) -> void:
	if(skating != new_skating):
		skating = new_skating
		emit_signal("skating_changed", skating)

func set_bob(new_bob) -> void:
	if(bob != new_bob):
		bob = new_bob
		emit_signal("bob_changed", bob)

# Getters
func get_yaw() -> float:
	return yaw

func get_pitch() -> float:
	return pitch

func get_velocity() -> Vector3:
	return velocity

func get_grounded() -> bool:
	return grounded

func get_stance() -> int:
	return stance

func get_prone_direction() -> Vector3:
	return prone_direction

func get_skating() -> bool:
	return grounded && skating

func get_bob() -> float:
	return bob

# Derived
func is_front_prone() -> bool:
	return prone_basis.dot(prone_direction) > 0.5

func is_back_prone() -> bool:
	return prone_basis.dot(prone_direction) < 0.5
