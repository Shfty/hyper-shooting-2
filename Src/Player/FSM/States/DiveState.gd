extends PlayerFSMState

func physics_process(delta):
	var player_state = .get_context_inst() as PlayerState
	var pitch = player_state.get_pitch()
	if(pitch > 0.0):
		if(pitch > PI):
			.exit("TuckRoll")
	elif(pitch < 0.0):
		if(pitch < -PI * 0.5):
			.exit("TuckRoll")
	.physics_process(delta)
