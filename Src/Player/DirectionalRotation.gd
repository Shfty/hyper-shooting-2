class_name DirectionalRotation
extends Node

export (Vector3) var rot_forward = Vector3.FORWARD setget set_rot_forward
export (float) var rot_angle = 0 setget set_rot_angle

func set_rot_forward(new_rot_forward):
	if(rot_forward != new_rot_forward):
		rot_forward = new_rot_forward
		update_rotation()

func set_rot_angle(new_rot_angle):
	if(rot_angle != new_rot_angle):
		rot_angle = new_rot_angle
		update_rotation()

func update_rotation():
	var dir = rot_forward.normalized()
	var axis = dir.cross(Vector3.DOWN).normalized()
	
	get_parent().global_transform.basis = Basis(axis, deg2rad(rot_angle))
