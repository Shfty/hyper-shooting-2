class_name DiveBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var wish_vector_key = "wish_vector"
export(String) var jump_action_key = "jump_action"

export(float) var jump_impulse = 10.295
export(float) var dive_impulse = 15.25

func dive_command():
	var wish_vector := get_context(wish_vector_key) as WishVector
	var jump_action := get_context(jump_action_key) as InputAction
	return wish_vector.get_wish_vector().length() > 0.5 && jump_action.pressed

# warning-ignore:unused_argument
func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var wish_vector := get_context(wish_vector_key) as WishVector
	var jump_action := get_context(jump_action_key) as InputAction
	
	var wish_vec = wish_vector.get_wish_vector().rotated(Vector3.UP, player_state.get_yaw())
	
	if(dive_command()):
		player_state.set_prone_direction(wish_vec)
		player_state.set_prone(true)
		jump_action.set_down(false)
		
		if(!player_state.get_skating()):
			var velocity = player_state.get_velocity()
			velocity = wish_vec.normalized() * dive_impulse
			velocity.y = jump_impulse
			
			player_state.set_grounded(false)
			player_state.set_velocity(velocity)
			parent_fsm.parent_fsm.exit("Airborne")

