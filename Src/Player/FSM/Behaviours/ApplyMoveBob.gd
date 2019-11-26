class_name ApplyMoveBob
extends NestedFSMBehavior

export(NodePath) var target_spatial
onready var target_spatial_inst = get_node(target_spatial) if !target_spatial.is_empty() else null

export(Curve) var bob_curve_x
export(Curve) var bob_curve_y
export(Curve) var bob_curve_z

export(Vector3) var bob_magnitude = Vector3(3, 3, 3)
export(Vector3) var curve_offset = Vector3.ZERO

# warning-ignore:unused_argument
func physics_process(delta):
	if(target_spatial_inst == null):
		return
	
	var player_state := get_context_inst() as PlayerState
	
	if(bob_curve_x):
		target_spatial_inst.translation.x = bob_curve_x.interpolate(player_state.get_bob() + curve_offset.x) * bob_magnitude.x
	
	if(bob_curve_y):
		target_spatial_inst.translation.y = bob_curve_y.interpolate(player_state.get_bob() + curve_offset.y) * bob_magnitude.y
	
	if(bob_curve_z):
		target_spatial_inst.translation.z = bob_curve_z.interpolate(player_state.get_bob() + curve_offset.z) * bob_magnitude.z
