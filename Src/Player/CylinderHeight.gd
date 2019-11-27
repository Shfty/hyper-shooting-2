class_name CylinderHeight
extends Node

export (NodePath) var cylinder
onready var cylinder_inst: CollisionShape = get_node(cylinder) if !cylinder.is_empty() else null

export (NodePath) var head_anchor
onready var head_anchor_inst: Spatial = get_node(head_anchor) if !head_anchor.is_empty() else null

export (NodePath) var feet_anchor
onready var feet_anchor_inst: Spatial = get_node(feet_anchor) if !feet_anchor.is_empty() else null

export(float) var head_inset = 0.23
export(float) var feet_inset = 0

func set_height(height):
	if(cylinder_inst == null):
		return
	
	# Change cylinder height
	var prev_height = cylinder_inst.shape.height
	cylinder_inst.shape.height = max(height, 0)
	
	# Delta movement to remain grounded
	var delta_height = cylinder_inst.shape.height - prev_height
	owner.global_transform.origin += Vector3(0, delta_height * 0.5, 0)
	
	# Reposition head and foot anchors
	if(head_anchor_inst != null):
		head_anchor_inst.translation.y = cylinder_inst.shape.height - head_inset
	
	if(feet_anchor_inst != null):
		feet_anchor_inst.translation.y = -(cylinder_inst.shape.height * 0.5) + feet_inset

func get_height():
	return cylinder_inst.shape.height
