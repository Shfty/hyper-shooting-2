class_name GetUpBehavior
extends NestedFSMBehavior

export(NodePath) var jump_action
onready var jump_action_inst = get_node(jump_action) if !jump_action.is_empty() else null

export(NodePath) var crouch_action
onready var crouch_action_inst = get_node(crouch_action) if !crouch_action.is_empty() else null

export(float) var front_prone_stop_threshold = 50.0
export(float) var back_prone_stop_threshold = 150.0

# warning-ignore:unused_argument
func physics_process(delta):
	if(jump_action_inst == null):
		return
		
	if(crouch_action_inst == null):
		return
		
	var player_state = get_context_inst() as PlayerState
	var velocity = player_state.get_velocity()
	var skating = player_state.get_skating()
	var get_up_threshold = front_prone_stop_threshold if player_state.is_front_prone() else back_prone_stop_threshold
		
	if(crouch_action_inst.down):
		if(jump_action_inst.down):
			if(skating || velocity.length() < get_up_threshold):
				player_state.set_prone(false)
				jump_action_inst.set_down(false)
	else:
		if(!skating && velocity.length() < get_up_threshold):
			player_state.set_prone(false)
			jump_action_inst.set_down(false)
