class_name CameraPitch
extends Node

export(bool) var lock_pitch = false

var player_state: PlayerState = null setget set_player_state

# Setters
func set_player_state(new_player_state):
	if(player_state != new_player_state):
		player_state = new_player_state

# Events
func mouse_move_y(delta):
	if(player_state == null):
		return
	
	if(!lock_pitch):
		var pitch = player_state.get_pitch()
		pitch += delta
		player_state.set_pitch(pitch)
