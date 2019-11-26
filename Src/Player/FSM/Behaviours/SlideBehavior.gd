class_name SlideBehavior
extends NestedFSMBehavior

export(NodePath) var crouching_height
onready var crouching_height_inst = get_node(crouching_height) if !crouching_height.is_empty() else null

export(float) var slide_impulse = 1200.0

func slide_command():
	return Input.is_action_just_pressed("move_forward")

# warning-ignore:unused_argument
func physics_process(delta):
	if(crouching_height_inst == null):
		return
	
	var player_state = get_context_inst() as PlayerState
	if(slide_command() && !crouching_height_inst.is_fully_transitioned()):
		var forward_vector = Vector3.FORWARD.rotated(Vector3.UP, player_state.get_yaw())
		player_state.set_prone_direction(-forward_vector)
		player_state.set_prone(true)
		var velocity = player_state.get_velocity()
		if(!player_state.get_skating()):
			#slide_limit = true
			velocity = forward_vector * slide_impulse
		player_state.set_velocity(velocity)
