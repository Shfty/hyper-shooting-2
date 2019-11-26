tool
class_name PlayerPitchLimit
extends Node

onready var camera_pitch: CameraPitch = get_parent()

var player_state: PlayerState = null setget set_player_state

func set_player_state(new_player_state):
	if(player_state != new_player_state):
		player_state = new_player_state
		
# warning-ignore:return_value_discarded
		player_state.connect("prone_changed", self, "update_pitch_limit")
# warning-ignore:return_value_discarded
		player_state.connect("grounded_changed", self, "update_pitch_limit")

func _get_configuration_warning():
	if(!get_parent() is CameraPitch):
		return "Parent must be a CameraPitch node"
	return ""

func should_run():
	return !Engine.is_editor_hint() && player_state != null

# warning-ignore:unused_argument
func update_pitch_limit(ignore):
	if(!should_run()):
		return
		
	var target_pitch_min = -89.0
	var target_pitch_max = 89.0
	
	if(player_state.get_prone()):
		if(player_state.get_grounded()):
			if(player_state.is_front_prone()):
				target_pitch_min = 0.0
				target_pitch_max = 44.0
			else:
				target_pitch_min = 0.0
				target_pitch_max = 179.0
	
	camera_pitch.pitch_min = target_pitch_min
	camera_pitch.pitch_max = target_pitch_max
