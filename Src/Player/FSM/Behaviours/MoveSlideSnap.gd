class_name MoveSlideSnapBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var kinematic_body_key = "kinematic_body"

export(Vector3) var snap_vector = Vector3.ZERO
export(Vector3) var floor_normal = Vector3.ZERO
export(bool) var stop_on_slope = false
export(int) var max_slides = 4
export(float) var max_slope_angle = 89.0

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var kinematic_body := get_context(kinematic_body_key) as KinematicBody

	var velocity = player_state.get_velocity()
	velocity = kinematic_body.move_and_slide_with_snap(velocity, snap_vector, floor_normal, stop_on_slope, max_slides, deg2rad(max_slope_angle))
	player_state.set_velocity(velocity)
