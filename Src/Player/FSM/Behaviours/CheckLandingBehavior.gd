class_name CheckLandingBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"

func physics_process(delta):
	var player_state = get_context(player_state_key) as PlayerState
	
	if(player_state.get_grounded() && !player_state.get_skating()):
		parent_fsm.exit("Grounded")
	
	.physics_process(delta)
