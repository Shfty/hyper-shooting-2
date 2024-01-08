class_name ApplyMoveBob
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var spatial_key = "spatial"

export(Curve) var bob_curve_x
export(Curve) var bob_curve_y
export(Curve) var bob_curve_z

export(Vector3) var bob_magnitude = Vector3(0.1, 0.1, 0.1)
export(Vector3) var curve_offset = Vector3.ZERO

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var spatial := get_context(spatial_key) as Spatial
	
	if(bob_curve_x):
		spatial.translation.x = bob_curve_x.interpolate(player_state.get_bob() + curve_offset.x) * bob_magnitude.x
	
	if(bob_curve_y):
		spatial.translation.y = bob_curve_y.interpolate(player_state.get_bob() + curve_offset.y) * bob_magnitude.y
	
	if(bob_curve_z):
		spatial.translation.z = bob_curve_z.interpolate(player_state.get_bob() + curve_offset.z) * bob_magnitude.z
