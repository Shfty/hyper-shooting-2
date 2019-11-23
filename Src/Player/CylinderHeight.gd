class_name CylinderHeight
extends Node
tool

export (float) var height = 56 setget set_height, get_height

signal height_changed(height)
signal height_changed_delta(delta_height)

func set_height(new_height):
	if(height != new_height):
		height = new_height
	
		var cylinder = get_parent().shape
		var prev_height = cylinder.height
		cylinder.height = max(height, 0)
		
		var delta_height = cylinder.height - prev_height
		
		emit_signal("height_changed", height)
		emit_signal("height_changed_delta", delta_height)

func get_height():
	return height

func should_run():
	if(Engine.is_editor_hint()):
		return false
	
	if(!is_parent_collision_shape()):
		return false
	
	return true

func is_parent_collision_shape():
	return get_parent() is CollisionShape

func _get_configuration_warning():
	if(!is_parent_collision_shape()):
		return "Parent must be a CollisionShape"
	
	return ""