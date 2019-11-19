extends Node

const MOVEMENT = "MovementController"
const CAMERA_YAW = "CameraYaw"
const CAMERA = "Camera"
var nodes = Util.NodeDependencies.new([
	MOVEMENT,
	CAMERA_YAW,
	CAMERA
])

export(float) var lean_factor = 0.01
export(float) var max_lean = 2.5

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var movement = nodes.get(MOVEMENT)
	var camera_yaw = nodes.get(CAMERA_YAW)
	var camera = nodes.get(CAMERA)
	
	var vel = movement.get("velocity")
	
	# Lean
	var lean = vel.dot(-camera_yaw.get_global_transform().basis.x) * lean_factor
	lean = clamp(lean, -max_lean, max_lean)
	camera.rotation.z = deg2rad(lean)
