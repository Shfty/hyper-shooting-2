class_name ResetMoveBobBehavior
extends NestedFSMBehavior

func enter():
	var player_state = get_context("player_state") as PlayerState
	player_state.set_bob(0.0)
