class_name LerpToZeroBehavior
extends NestedFSMBehavior

export(NodePath) var spatial
onready var spatial_inst = get_node(spatial) if !spatial.is_empty() else null

export (Vector3) var translation = Vector3.ZERO
export (Vector3) var rotation = Vector3.ZERO
export (Vector3) var scale = Vector3.ONE

export (float) var transition_speed = 6.0

func process(delta):
	if(spatial_inst == null):
		return
	
	spatial_inst.translation = lerp(spatial_inst.translation, translation, delta * transition_speed)
	spatial_inst.rotation = lerp(spatial_inst.rotation, rotation, delta * transition_speed)
	spatial_inst.scale = lerp(spatial_inst.scale, scale, delta * transition_speed)
