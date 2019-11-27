class_name SlideBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var crouching_height_key = "crouching_height"

export(float) var slide_impulse = 45.75

func slide_command():
	return Input.is_action_just_pressed("move_forward")

# warning-ignore:unused_argument
func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var crouching_height := get_context(crouching_height_key) as CylinderHeightBehavior
	
	if(slide_command() && !crouching_height.is_fully_transitioned()):
		var forward_vector = Vector3.FORWARD.rotated(Vector3.UP, player_state.get_yaw())
		player_state.set_prone_direction(-forward_vector)
		player_state.set_prone(true)
		var velocity = player_state.get_velocity()
		if(!player_state.get_skating()):
			#slide_limit = true
			velocity = forward_vector * slide_impulse
		player_state.set_velocity(velocity)
