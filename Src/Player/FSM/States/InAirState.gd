extends NestedFSMState

export(String) var player_state_key = "player_state"

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	
	if(player_state.get_stance() == PlayerState.Stance.PRONE):
		return root_fsm.change_to("Airborne/Dive")
	
	var pitch = player_state.get_pitch()
	
	if(pitch > 0.0):
		if(pitch > PI * 0.5 && pitch < PI):
			root_fsm.change_to("Airborne/Dive")
		elif(pitch > PI && pitch < PI * 1.5):
			root_fsm.change_to("Airborne/TuckRoll")
	elif(pitch < 0.0):
		if(pitch < -PI * 0.5):
			root_fsm.change_to("Airborne/TuckRoll")
