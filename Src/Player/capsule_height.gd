extends Node

var nodes = Util.NodeDependencies.new([
	PN.Spatial.KINEMATIC_BODY,
	PN.Spatial.COLLISION_SHAPE,
	PN.Spatial.HEAD_ANCHOR,
	PN.Spatial.FEET_ANCHOR,
	PN.Spatial.UNCROUCH_RAYCAST,
	PN.Spatial.CAMERA_OFFSET
])

export (float) var height = 56

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var player = nodes.get(PN.Spatial.KINEMATIC_BODY)
	var shape = nodes.get(PN.Spatial.COLLISION_SHAPE)
	var head_anchor = nodes.get(PN.Spatial.HEAD_ANCHOR)
	var feet_anchor = nodes.get(PN.Spatial.FEET_ANCHOR)
	var uncrouch_raycast = nodes.get(PN.Spatial.UNCROUCH_RAYCAST)
	var camera_offset = nodes.get(PN.Spatial.CAMERA_OFFSET)
	
	var capsule = shape.shape
	var prev_height = capsule.height
	capsule.height = max(height - (capsule.radius * 2), 0)
	
	head_anchor.translation.y = capsule.height * 0.5
	feet_anchor.translation.y = -capsule.height * 0.5
	
	uncrouch_raycast.set_global_transform(Transform(Basis(), feet_anchor.get_global_transform().origin))
	camera_offset.set_global_transform(Transform(Basis(), head_anchor.get_global_transform().origin))
	
	var delta_height = capsule.height - prev_height
	player.translation.y += delta_height * 0.5
