class_name PlayerGravityBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"

export(float) var gravity = -30.5

func physics_process(delta):
	var player_state = get_context(player_state_key) as PlayerState
	if(player_state):
		player_state.set_velocity(player_state.get_velocity() + Vector3(0, gravity * delta, 0))
