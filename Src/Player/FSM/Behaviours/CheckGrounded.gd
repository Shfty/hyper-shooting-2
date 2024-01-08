extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var kinematic_body_key = "kinematic_body"

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var kinematic_body := get_context(kinematic_body_key) as KinematicBody
	player_state.set_grounded(kinematic_body.is_on_floor())
