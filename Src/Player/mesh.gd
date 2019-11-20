extends Node

var nodes = Util.NodeDependencies.new([
	PN.Models.INPUT,
	PN.Spatial.PLAYER_MESH
])

export(float) var recenter_speed = 10

var lerp_pitch = false

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var input = nodes.get(PN.Models.INPUT)
	var player_mesh = nodes.get(PN.Spatial.PLAYER_MESH)
	
	var rotation = input.get_prop(PlayerInputs.CAMERA_ROTATION)
	player_mesh.rotation.y = rotation.y
