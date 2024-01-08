extends NestedFSMState

export(String) var player_state_key = "player_state"
export(String) var crouch_action_key = "crouch_action"

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var crouch_action := get_context(crouch_action_key) as InputAction
	
	if(!crouch_action.get_down()):
		root_fsm.change_to("Grounded/Standing")
	