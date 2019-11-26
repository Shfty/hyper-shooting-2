class_name LeanRollBehavior
extends NestedFSMBehavior

export(NodePath) var lean_roll_spatial
onready var lean_roll_spatial_inst = get_node(lean_roll_spatial) if !lean_roll_spatial.is_empty() else null

export(float) var lean_factor = 0.01
export(float) var max_lean = 2.5

# warning-ignore:unused_argument
func physics_process(delta):
	if(lean_roll_spatial_inst == null):
		return
	
	var player_state = get_context_inst() as PlayerState
	var velocity = player_state.get_velocity()
	
	var lean = velocity.dot(-lean_roll_spatial_inst.global_transform.basis.x) * lean_factor
	lean = clamp(lean, -max_lean, max_lean)
	lean_roll_spatial_inst.rotation.z = deg2rad(lean)
