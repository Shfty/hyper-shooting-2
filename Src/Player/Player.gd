class_name Player
extends KinematicBody

onready var player_state = $PlayerState

func _ready():
	# Initialize rotation
	player_state.set_yaw(rotation.y)
