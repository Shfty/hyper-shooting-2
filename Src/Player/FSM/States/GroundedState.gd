class_name GroundedState
extends NestedFSMState

func get_default_state():
	var player_state = .get_context_inst() as PlayerState
	if(player_state.get_prone()):
		return "Prone"
	elif(player_state.get_crouching()):
		return "Crouching"
	else:
		return "Standing"

func physics_process(delta):
	var player_state = .get_context_inst() as PlayerState
	if(!player_state.get_grounded() || player_state.get_skating()):
		.exit("Airborne")
	.physics_process(delta)
