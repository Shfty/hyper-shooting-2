class_name Player
extends KinematicBody

onready var player_state: PlayerState = $PlayerState

func _ready():
	# Initialize rotation
	player_state.set_yaw(rotation.y)

func get_player_state() -> PlayerState:
	return player_state

# Utility
func mouse_move_x(delta):
	var yawSign = 1 if abs(player_state.get_pitch()) >= PI * 0.5 else -1
	player_state.set_yaw(player_state.get_yaw() + delta * yawSign)

func mouse_move_y(delta):
	player_state.set_pitch(player_state.get_pitch() + delta)
