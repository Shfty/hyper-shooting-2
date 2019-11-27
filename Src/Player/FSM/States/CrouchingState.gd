extends PlayerFSMState

func physics_process(delta):
	var player_state = .get_context("player_state") as PlayerState
	if(player_state.get_prone()):
		.exit("Prone")
	elif(!player_state.get_crouching()):
		.exit("Standing")
	.physics_process(delta)
