class_name MoveSlideSnapBehavior
extends NestedFSMBehavior

export(NodePath) var kinematic_body
onready var kinematic_body_inst = get_node(kinematic_body) if !kinematic_body.is_empty() else null

export(Vector3) var snap_vector = Vector3.ZERO
export(Vector3) var floor_normal = Vector3.ZERO
export(bool) var stop_on_slope = false
export(int) var max_slides = 4
export(float) var max_slope_angle = 89.0

func physics_process(delta):
	if(kinematic_body_inst == null):
		return
	
	var player_state = get_context_inst() as PlayerState
	var grounded = player_state.get_grounded()
	
	var velocity = player_state.get_velocity()
	velocity = kinematic_body_inst.move_and_slide_with_snap(velocity, snap_vector, floor_normal, stop_on_slope, max_slides, deg2rad(max_slope_angle))
	player_state.set_velocity(velocity)
