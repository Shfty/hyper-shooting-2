class_name GroundedState
extends NestedFSMState

export(String) var player_state_key = "player_state"
export(String) var crouch_action_key = "crouch_action"

func enter(from_state):
	var crouch_action := get_context(crouch_action_key) as InputAction
	
	if(from_state == "Dive"):
		root_fsm.change_to("Grounded/Prone")
	
	if(crouch_action.get_down()):
		root_fsm.change_to("Grounded/Crouching")
		
	root_fsm.change_to("Grounded/Standing")

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	
	if(!player_state.get_grounded() || player_state.get_skating()):
		root_fsm.change_to("Airborne/InAir")
