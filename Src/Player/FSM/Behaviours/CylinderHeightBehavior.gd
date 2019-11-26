class_name CylinderHeightBehavior
extends NestedFSMBehavior

export(NodePath) var cylinder_height
export(float) var height = 56
export(float) var height_transition_speed = 10

onready var cylinder_height_inst = get_node(cylinder_height) if !cylinder_height.is_empty() else null

func physics_process(delta):
	if(cylinder_height_inst):
		cylinder_height_inst.set_height(lerp(cylinder_height_inst.get_height(), height, height_transition_speed * delta))

func is_fully_transitioned():
	return cylinder_height_inst.get_height() < height + 1.0
