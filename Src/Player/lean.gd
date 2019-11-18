extends Node

const PLAYER = "KinematicBody"
const CAMERA = "Camera"
var nodes = Util.NodeDependencies.new([
	PLAYER,
	CAMERA
])

var last_pos: Vector3 = Vector3.ZERO

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var player = nodes.get(PLAYER)
	var camera = nodes.get(CAMERA)
	
	var vel = player.translation - last_pos
	
	# Lean
	var lean = vel.dot(-player.get_global_transform().basis.x)
	camera.rotation.z = deg2rad(lean)
	
	last_pos = player.translation
