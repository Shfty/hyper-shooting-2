class_name JumpBehavior
extends NestedFSMBehavior

export(NodePath) var kinematic_body
onready var kinematic_body_inst = get_node(kinematic_body) if !kinematic_body.is_empty() else null

export(NodePath) var jump_action
onready var jump_action_inst = get_node(jump_action) if !jump_action.is_empty() else null

export(float) var jump_impulse = 270

# warning-ignore:unused_argument
func physics_process(delta):
	if(kinematic_body_inst == null):
		return
	
	if(jump_action_inst == null):
		return
	
	if(kinematic_body_inst.is_on_floor() && jump_action_inst.down):
		var player_state = get_context_inst() as PlayerState
		
		var velocity = player_state.get_velocity()
		velocity.y = jump_impulse
		player_state.set_velocity(velocity)
		
		jump_action_inst.set_down(false)
		player_state.set_grounded(false)
		parent_fsm.parent_fsm.exit("Airborne")
