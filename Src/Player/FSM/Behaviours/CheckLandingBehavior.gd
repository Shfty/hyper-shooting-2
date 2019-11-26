class_name CheckLandingBehavior
extends NestedFSMBehavior

func physics_process(delta):
	var player_state = get_context_inst() as PlayerState
	if(player_state.get_grounded() && !player_state.get_skating()):
		parent_fsm.exit("Grounded")
	.physics_process(delta)
