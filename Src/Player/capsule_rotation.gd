extends Node

var nodes = Util.NodeDependencies.new([
	PN.Spatial.KINEMATIC_BODY,
])

export (Vector3) var rot_forward = Vector3.FORWARD
export (float) var rot_angle = 0

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var player = nodes.get(PN.Spatial.KINEMATIC_BODY)
	
	var dir = rot_forward.normalized()
	var axis = dir.cross(Vector3.DOWN).normalized()
	
	player.global_transform.basis = Basis(axis, deg2rad(rot_angle))
	
	