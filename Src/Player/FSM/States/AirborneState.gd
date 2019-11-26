extends PlayerFSMState

func get_default_state():
	var player_state = .get_context_inst() as PlayerState
	if(player_state.get_prone()):
		return "Dive"
	else:
		return "InAir"
