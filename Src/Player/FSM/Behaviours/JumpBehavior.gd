class_name JumpBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var kinematic_body_key = "kinematic_body"
export(String) var jump_action_key = "jump_action"

export(float) var jump_impulse = 10.3

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var kinematic_body := get_context(kinematic_body_key) as KinematicBody
	var jump_action := get_context(jump_action_key) as InputAction
	
	if(kinematic_body.is_on_floor() && jump_action.down):
		
		var velocity = player_state.get_velocity()
		velocity.y = jump_impulse
		player_state.set_velocity(velocity)
		
		jump_action.set_down(false)
		player_state.set_grounded(false)
		root_fsm.change_to("Airborne/InAir")
