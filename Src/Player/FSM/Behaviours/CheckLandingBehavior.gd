class_name CheckLandingBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var target_path = "Grounded"

func physics_process(delta):
	var player_state = .get_context(player_state_key) as PlayerState
	
	if(player_state.get_grounded() && !player_state.get_skating()):
		self.root_fsm.change_to(target_path)
	