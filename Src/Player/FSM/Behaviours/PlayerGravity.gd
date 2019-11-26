class_name PlayerGravityBehavior
extends NestedFSMBehavior

export(float) var gravity = -800.0

func physics_process(delta):
	var player_state = get_context_inst() as PlayerState
	if(player_state):
		player_state.set_velocity(player_state.get_velocity() + Vector3(0, gravity * delta, 0))
