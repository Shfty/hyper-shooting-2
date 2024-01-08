class_name GetUpBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var jump_action_key = "jump_action"
export(String) var crouch_action_key = "crouch_action"

export(float) var front_prone_stop_threshold = 1.9
export(float) var back_prone_stop_threshold = 5.72

func physics_process(delta):
	var player_state = get_context(player_state_key) as PlayerState
	var jump_action := get_context(jump_action_key) as InputAction
	var crouch_action := get_context(crouch_action_key) as InputAction
		
	var velocity = player_state.get_velocity()
	velocity.y = 0
	
	var skating = player_state.get_skating()
	var get_up_threshold = front_prone_stop_threshold if player_state.is_front_prone() else back_prone_stop_threshold
	
	if(crouch_action.down):
		if(jump_action.down):
			if(skating || velocity.length() < get_up_threshold):
				jump_action.set_down(false)
				root_fsm.change_to("Grounded/Standing")
	else:
		if(!skating && velocity.length() < get_up_threshold):
			jump_action.set_down(false)
			root_fsm.change_to("Grounded/Standing")
