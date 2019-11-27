extends PlayerFSMState

func physics_process(delta):
	var player_state = .get_context("player_state") as PlayerState
	if(player_state.get_prone()):
		return .exit("Dive")
	
	var pitch = player_state.get_pitch()
	if(pitch > 0.0):
		if(pitch > PI * 0.5 && pitch < PI):
			.exit("Dive")
		elif(pitch > PI && pitch < PI * 1.5):
			.exit("TuckRoll")
	elif(pitch < 0.0):
		if(pitch < -PI * 0.5):
			.exit("TuckRoll")
	.physics_process(delta)
