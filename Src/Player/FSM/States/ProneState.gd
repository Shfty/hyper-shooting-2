extends NestedFSMState

export(String) var player_state_key = "player_state"

func enter(from_state):
	var player_state := get_context(player_state_key) as PlayerState
	if(player_state.is_front_prone()):
		root_fsm.change_to("Grounded/Prone/FrontProne")
	else:
		root_fsm.change_to("Grounded/Prone/BackProne")