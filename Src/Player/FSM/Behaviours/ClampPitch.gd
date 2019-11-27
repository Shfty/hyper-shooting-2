class_name ClampPitchBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"

export(float) var pitch_min = -89.0
export(float) var pitch_max = 89.0

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var pitch = player_state.get_pitch()
	pitch = clamp(pitch, deg2rad(pitch_min), deg2rad(pitch_max))
	player_state.set_pitch(pitch)
