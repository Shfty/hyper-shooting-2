class_name Player
extends KinematicBody

onready var player_state: PlayerState = $PlayerState

func _ready():
	# Initialize rotation
	player_state.set_yaw(rotation.y)

func get_player_state() -> PlayerState:
	return player_state
