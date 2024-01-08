class_name LeanRollBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var lean_roll_spatial_key = "lean_roll_spatial"

export(float) var lean_factor = 0.01
export(float) var max_lean = 2.5

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var lean_roll_spatial := get_context(lean_roll_spatial_key) as Spatial
	
	var velocity = player_state.get_velocity()
	
	var lean = velocity.dot(-lean_roll_spatial.global_transform.basis.x) * lean_factor
	lean = clamp(lean, -max_lean, max_lean)
	lean_roll_spatial.rotation.z = deg2rad(lean)
