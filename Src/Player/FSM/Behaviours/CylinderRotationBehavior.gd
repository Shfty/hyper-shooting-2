class_name CylinderRotationBehavior
extends NestedFSMBehavior

export(String) var directional_rotation_key = "directional_rotation"

export(float) var rotation_angle = 0.0
export(float) var rotation_transition_speed = 10.0

func physics_process(delta):
	var directional_rotation := get_context(directional_rotation_key) as DirectionalRotation
	directional_rotation.set_rot_angle(lerp(directional_rotation.get_rot_angle(), rotation_angle, rotation_transition_speed * delta))
