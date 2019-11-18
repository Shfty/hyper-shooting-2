extends Node

const PLAYER = "KinematicBody"
const CAMERA_PIVOT = "CameraPivot"
const MOVEMENT = "MovementController"
const WEAPON_ANCHOR = "GunBobAnchor"
var nodes = Util.NodeDependencies.new([
	PLAYER,
	CAMERA_PIVOT,
	MOVEMENT,
	WEAPON_ANCHOR
])

export (Vector3) var momentum_scale = Vector3(1, 1, 0.8)

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var player = nodes.get(PLAYER)
	var camera_pivot = nodes.get(CAMERA_PIVOT)
	var movement = nodes.get(MOVEMENT)
	var weapon_anchor = nodes.get(WEAPON_ANCHOR)
	
	var target = Vector3()
	
	if(!movement.get("grounded") || movement.get("skating")):
		var vel = movement.get("velocity")
		vel = vel.rotated(Vector3.UP, -player.rotation.y)
		vel = vel.rotated(Vector3.RIGHT, -camera_pivot.rotation.x)
		
		target = vel * momentum_scale * -0.002

	weapon_anchor.translation = lerp(weapon_anchor.translation, target, 0.1)
