extends Node

var nodes = Util.NodeDependencies.new([
	PN.Models.STATE,
	PN.Spatial.CAMERA_YAW,
	PN.Spatial.CAMERA
])

export(float) var lean_factor = 0.01
export(float) var max_lean = 2.5

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var state = nodes.get(PN.Models.STATE)
	var camera_yaw = nodes.get(PN.Spatial.CAMERA_YAW)
	var camera = nodes.get(PN.Spatial.CAMERA)
	
	var vel = state.get_prop(PP.VELOCITY)
	
	# Lean
	var lean = vel.dot(-camera_yaw.get_global_transform().basis.x) * lean_factor
	lean = clamp(lean, -max_lean, max_lean)
	camera.rotation.z = deg2rad(lean)
