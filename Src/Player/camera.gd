extends Node

var nodes = Util.NodeDependencies.new([
	PN.Models.INPUT,
	PN.Models.STATE,
	PN.Spatial.CAMERA_YAW,
	PN.Spatial.CAMERA_PITCH
])

export(float) var recenter_speed = 10

var lerp_pitch = false

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var input = nodes.get(PN.Models.INPUT)
	var state = nodes.get(PN.Models.STATE)
	var camera_yaw = nodes.get(PN.Spatial.CAMERA_YAW)
	var camera_pitch = nodes.get(PN.Spatial.CAMERA_PITCH)
	
	var free_look = state.get_skating_state() || (!state.get_prop(PP.DIVING) && !state.get_prop(PP.GROUNDED))
	input.set("clamp_pitch", !free_look)
	
	var target_pitch_min = -89.0
	var target_pitch_max = 89.0
	var clamp_yaw = false
	var yaw_limit = 0
	match state.get_action_state():
		state.ACTION_STATE.BACK_PRONE:
			target_pitch_min = 0
			target_pitch_max = 179
			clamp_yaw = true
			yaw_limit = 80
		state.ACTION_STATE.FRONT_PRONE:
			target_pitch_min = 0
			target_pitch_max = 44
			clamp_yaw = true
			yaw_limit = 80
		state.ACTION_STATE.AIR_DIVE:
			target_pitch_min = -80
			target_pitch_max = 80
			clamp_yaw = true
			yaw_limit = 80
	
	input.set("pitch_min", target_pitch_min)
	input.set("pitch_max", target_pitch_max)
	input.set("clamp_yaw", clamp_yaw)
	input.set("yaw_limit", yaw_limit)
	
	var rotation = input.get_prop(PlayerInputs.CAMERA_ROTATION)
	var in_bounds = rotation.x < deg2rad(input.get("pitch_max") + 1) && rotation.x > deg2rad(input.get("pitch_min") - 1)
	if(!free_look && !in_bounds):
		lerp_pitch = true
	
	input.set("lock_pitch", lerp_pitch)
	if(lerp_pitch):
		rotation.x = lerp(rotation.x, 0, delta * recenter_speed)
		if(abs(rotation.x) < deg2rad(1.0)):
			lerp_pitch = false
	input.set_prop(PlayerInputs.CAMERA_ROTATION, rotation)
	
	camera_yaw.rotation.y = rotation.y
	camera_pitch.rotation.x = rotation.x
