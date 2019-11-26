class_name DiveBehavior
extends NestedFSMBehavior

export(NodePath) var wish_vector
onready var wish_vector_inst = get_node(wish_vector) if !wish_vector.is_empty() else null

export(NodePath) var jump_action
onready var jump_action_inst = get_node(jump_action) if !jump_action.is_empty() else null

export(float) var jump_impulse = 270
export(float) var dive_impulse = 400.0

func dive_command():
	return wish_vector_inst.get_wish_vector().length() > 0.5 && jump_action_inst.pressed

# warning-ignore:unused_argument
func physics_process(delta):
	if(wish_vector_inst == null):
		return
		
	if(jump_action_inst == null):
		return
	
	var player_state = get_context_inst() as PlayerState
	var wish_vec = wish_vector_inst.get_wish_vector().rotated(Vector3.UP, player_state.get_yaw())
	
	if(dive_command()):
		player_state.set_prone_direction(wish_vec)
		player_state.set_prone(true)
		jump_action_inst.set_down(false)
		
		if(!player_state.get_skating()):
			var velocity = player_state.get_velocity()
			velocity = wish_vec.normalized() * dive_impulse
			velocity.y = jump_impulse
			
			player_state.set_grounded(false)
			player_state.set_velocity(velocity)
			parent_fsm.parent_fsm.exit("Airborne")

