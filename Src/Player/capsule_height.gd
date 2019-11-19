extends Node

const PLAYER = "KinematicBody"
const SHAPE = "CollisionShape"
const HEAD_ANCHOR = "HeadAnchor"
const FEET_ANCHOR = "FeetAnchor"
const UNCROUCH_RAYCAST = "UncrouchRayCast"
const CAMERA_OFFSET = "CameraOffset"
var nodes = Util.NodeDependencies.new([
	PLAYER,
	SHAPE,
	HEAD_ANCHOR,
	FEET_ANCHOR,
	UNCROUCH_RAYCAST,
	CAMERA_OFFSET
])

export (float) var height = 56

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var player = nodes.get(PLAYER)
	var shape = nodes.get(SHAPE)
	var head_anchor = nodes.get(HEAD_ANCHOR)
	var feet_anchor = nodes.get(FEET_ANCHOR)
	var uncrouch_raycast = nodes.get(UNCROUCH_RAYCAST)
	var camera_offset = nodes.get(CAMERA_OFFSET)
	
	var capsule = shape.shape
	var prev_height = capsule.height
	capsule.height = max(height - (capsule.radius * 2), 0)
	
	head_anchor.translation.y = capsule.height * 0.5
	feet_anchor.translation.y = -capsule.height * 0.5
	
	uncrouch_raycast.set_global_transform(Transform(Basis(), feet_anchor.get_global_transform().origin))
	camera_offset.set_global_transform(Transform(Basis(), head_anchor.get_global_transform().origin))
	
	var delta_height = capsule.height - prev_height
	player.translation.y += delta_height * 0.5
