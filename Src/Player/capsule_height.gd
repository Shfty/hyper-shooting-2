extends Node

const PLAYER = "KinematicBody"
const SHAPE = "CollisionShape"
const CAMERA_ANCHOR = "CameraAnchor"
const CAMERA_OFFSET = "CameraOffset"
var nodes = Util.NodeDependencies.new([
	PLAYER,
	SHAPE,
	CAMERA_ANCHOR,
	CAMERA_OFFSET
])

export (float) var height = 56

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var player = nodes.get(PLAYER)
	var shape = nodes.get(SHAPE)
	var camera_anchor = nodes.get(CAMERA_ANCHOR)
	var camera_offset = nodes.get(CAMERA_OFFSET)
	
	var capsule = shape.shape
	var prev_height = capsule.height
	capsule.height = max(height - (capsule.radius * 2), 0)
	
	camera_anchor.translation.y = capsule.height * 0.5
	camera_offset.set_global_transform(Transform(Basis(), camera_anchor.get_global_transform().origin))
	
	var delta_height = capsule.height - prev_height
	player.translation.y += delta_height
