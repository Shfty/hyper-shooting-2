class_name CylinderRotationBehavior
extends NestedFSMBehavior

export(NodePath) var directional_rotation
onready var directional_rotation_inst = get_node(directional_rotation) if !directional_rotation.is_empty() else null

export(float) var rotation_angle = 0.0
export(float) var rotation_transition_speed = 10.0

func physics_process(delta):
	if(directional_rotation_inst == null):
		return
		
	directional_rotation_inst.set_rot_angle(lerp(directional_rotation_inst.get_rot_angle(), rotation_angle, rotation_transition_speed * delta))
