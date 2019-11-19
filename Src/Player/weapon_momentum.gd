extends Node

const CAMERA_YAW = "CameraYaw"
const CAMERA_PITCH = "CameraPitch"
const MOVEMENT = "MovementController"
const WEAPON_ANCHOR = "GunBobAnchor"
var nodes = Util.NodeDependencies.new([
	CAMERA_YAW,
	CAMERA_PITCH,
	MOVEMENT,
	WEAPON_ANCHOR
])

export (Vector3) var momentum_scale = Vector3(1.2, 1.2, 0.8)

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var camera_yaw = nodes.get(CAMERA_YAW)
	var camera_pitch = nodes.get(CAMERA_PITCH)
	var movement = nodes.get(MOVEMENT)
	var weapon_anchor = nodes.get(WEAPON_ANCHOR)
	
	var target = Vector3()
	
	if(!movement.get("grounded") || movement.get("skating")):
		var vel = movement.get("velocity")
		vel = vel.rotated(Vector3.UP, -camera_yaw.rotation.y)
		vel = vel.rotated(Vector3.RIGHT, -camera_pitch.rotation.x)
		
		target = vel * momentum_scale * -0.002

	weapon_anchor.translation = lerp(weapon_anchor.translation, target, 0.1)
