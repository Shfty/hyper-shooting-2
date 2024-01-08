class_name FloorMovementBehavior
extends NestedFSMBehavior

export(String) var kinematic_body_key = "kinematic_body"

func physics_process(delta):
	var kinematic_body := get_context(kinematic_body_key) as KinematicBody
	kinematic_body.global_transform.origin += kinematic_body.get_floor_velocity()
