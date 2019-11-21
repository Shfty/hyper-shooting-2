extends Node

var nodes = Util.NodeDependencies.new([
	PN.Models.INPUT,
	PN.Models.STATE,
	PN.Spatial.CAMERA_YAW,
	PN.Spatial.CAMERA_PITCH,
	PN.Spatial.WEAPON_ANCHOR
])

export (Vector3) var momentum_scale = Vector3(1.2, 1.2, 0.8)

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var input = nodes.get(PN.Models.INPUT)
	var state = nodes.get(PN.Models.STATE)
	var camera_yaw = nodes.get(PN.Spatial.CAMERA_YAW)
	var camera_pitch = nodes.get(PN.Spatial.CAMERA_PITCH)
	var weapon_anchor = nodes.get(PN.Spatial.WEAPON_ANCHOR)
	
	var grounded = state.get_prop(PP.GROUNDED)
	var skating = input.get_prop(PlayerInputs.SKATE)
	
	var target = Vector3()
	if(!grounded || skating):
		var vel = state.get_prop(PP.VELOCITY)
		vel = vel.rotated(Vector3.UP, -camera_yaw.global_transform.basis.get_euler().y)
		vel = vel.rotated(Vector3.RIGHT, -camera_pitch.global_transform.basis.get_euler().x)
		
		target = vel * momentum_scale * -0.002

	weapon_anchor.translation = lerp(weapon_anchor.translation, target, 0.1)
