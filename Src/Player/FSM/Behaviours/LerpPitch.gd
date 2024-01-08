class_name LerpPitchBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"

export(bool) var active = false setget set_active
export(bool) var long_way_around = false

export(float) var pitch_min = -89.0
export(float) var pitch_max = 89.0
export(float) var target = 0
export(float) var speed = 10.0
export(float) var stop_threshold = 0.1

signal active_changed(active)

func set_active(new_active):
	if(active != new_active):
		active = new_active
	emit_signal("active_changed", active)

func enter(from_state):
	var player_state := get_context(player_state_key) as PlayerState
	var pitch = player_state.get_pitch()
	var out_of_bounds = pitch > deg2rad(pitch_max) || pitch < deg2rad(pitch_min)
	if(out_of_bounds):
		if(long_way_around):
			pitch -= TAU * sign(pitch)
			player_state.set_pitch(pitch)
		set_active(true)
	else:
		set_active(false)

func exit(next_state):
	set_active(false)

func physics_process(delta):
	if(active):
		var player_state := get_context(player_state_key) as PlayerState
		var pitch = player_state.get_pitch()
		pitch = lerp(pitch, target, speed * delta)
		player_state.set_pitch(pitch)
		
		if(abs(pitch - target) < stop_threshold):
			set_active(false)
