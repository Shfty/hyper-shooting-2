extends NestedFSMState

export(String) var player_state_key = "player_state"

func get_default_state(from_state):
	return "InAir"
