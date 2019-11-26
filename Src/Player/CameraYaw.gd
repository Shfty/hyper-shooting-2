class_name CameraYaw
extends Node

var player_state: PlayerState = null setget set_player_state

# Setters
func set_player_state(new_player_state):
	if(player_state != new_player_state):
		player_state = new_player_state

# Events
func mouse_move_x(delta):
	if(player_state == null):
		return
	
	# Yaw
	var yawSign = 1 if abs(player_state.get_pitch()) >= PI * 0.5 else -1
	var yaw = player_state.get_yaw()
	yaw += delta * yawSign
	player_state.set_yaw(yaw)
