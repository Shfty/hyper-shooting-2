extends PlayerFSMState

func physics_process(delta):
	.physics_process(delta)
	var player_state = .get_context_inst() as PlayerState
	if(player_state.get_prone()):
		exit("Prone")
	elif(player_state.get_crouching()):
		exit("Crouching")
	.physics_process(delta)
