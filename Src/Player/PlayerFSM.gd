class_name PlayerFSM
extends Node

onready var player_state: PlayerState = get_node("../PlayerState")
onready var crouch_action: InputAction = get_node("../Input/CrouchAction")
onready var skate_action: InputAction = get_node("../Input/SkateAction")

enum ACTION_STATE {
	STANDING,
	CROUCHING,
	FRONT_PRONE,
	BACK_PRONE,
	IN_AIR,
	AIR_DIVE,
	TUCK_ROLL,
	WALL_SLIDE
}

func get_action_state():
	if(player_state.get_grounded()):
		if(player_state.get_sliding()):
			return ACTION_STATE.BACK_PRONE
		if(player_state.get_diving()):
			return ACTION_STATE.FRONT_PRONE
		if(crouch_action.down):
			return ACTION_STATE.CROUCHING
		return ACTION_STATE.STANDING
	else:
		if(player_state.get_diving()):
			return ACTION_STATE.AIR_DIVE
		return ACTION_STATE.IN_AIR

func get_skating_state():
	return player_state.get_grounded() && skate_action.down

func get_sliding_state():
	return player_state.get_sliding()

func get_diving_state():
	return player_state.get_diving()
