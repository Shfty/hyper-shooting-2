class_name ClampPitchBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"

export(bool) var active = true setget set_active

export(float) var pitch_min = -89.0
export(float) var pitch_max = 89.0

func set_active(new_active):
	if(active != new_active):
		active = new_active

func set_inactive(new_inactive):
	set_active(!new_inactive)

func physics_process(delta):
	if(active):
		var player_state := get_context(player_state_key) as PlayerState
		var pitch = player_state.get_pitch()
		pitch = clamp(pitch, deg2rad(pitch_min), deg2rad(pitch_max))
		player_state.set_pitch(pitch)
