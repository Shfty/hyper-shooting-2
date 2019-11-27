extends PlayerFSMState

func physics_process(delta):
	var player_state = .get_context("player_state") as PlayerState
	var pitch = player_state.get_pitch()
	if(pitch > -PI * 0.5 && pitch < PI * 0.5):
		.exit("InAir")
	.physics_process(delta)
