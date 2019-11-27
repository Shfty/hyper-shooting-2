class_name CylinderHeightBehavior
extends NestedFSMBehavior

export(String) var cylinder_height_key = "cylinder_height"

export(float) var height = 1.8
export(float) var height_transition_speed = 10
export(float) var full_transition_threshold = 0.08

func physics_process(delta):
	var cylinder_height := get_context(cylinder_height_key) as CylinderHeight
	cylinder_height.set_height(lerp(cylinder_height.get_height(), height, height_transition_speed * delta))

func is_fully_transitioned():
	var cylinder_height := get_context(cylinder_height_key) as CylinderHeight
	return cylinder_height.get_height() < height + full_transition_threshold
