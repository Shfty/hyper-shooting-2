extends Node

var nodes = Util.NodeDependencies.new([
	PN.Models.INPUT,
	PN.Models.STATE,
	PN.Spatial.CAMERA_YAW,
	PN.Spatial.CAMERA_PITCH,
	PN.Controllers.CAPSULE_ROTATION
])

export(float) var recenter_speed = 10

enum LERP_MODE {
	NONE,
	NEUTRAL,
	PITCH_MIN,
	PITCH_MAX
}

var lerp_pitch = LERP_MODE.NONE

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var input = nodes.get(PN.Models.INPUT)
	var state = nodes.get(PN.Models.STATE)
	var camera_yaw = nodes.get(PN.Spatial.CAMERA_YAW)
	var camera_pitch = nodes.get(PN.Spatial.CAMERA_PITCH)
	var capsule_rotation = nodes.get(PN.Controllers.CAPSULE_ROTATION)
	
	var target_pitch_min = -89.0
	var target_pitch_max = 89.0
	var clamp_yaw = false
	var yaw_limit = 0.0
	match state.get_action_state():
		state.ACTION_STATE.BACK_PRONE:
			target_pitch_min = 0.0
			target_pitch_max = 179.0
			clamp_yaw = true
			yaw_limit = 80.0
		state.ACTION_STATE.FRONT_PRONE:
			target_pitch_min = 0.0
			target_pitch_max = 44.0
			clamp_yaw = true
			yaw_limit = 80.0
		state.ACTION_STATE.AIR_DIVE:
			target_pitch_min = -89.0
			target_pitch_max = 89.0
			clamp_yaw = true
			yaw_limit = 80.0
	
	input.set("pitch_min", target_pitch_min)
	input.set("pitch_max", target_pitch_max)
	input.set("clamp_yaw", clamp_yaw)
	input.set("yaw_limit", yaw_limit)
	
	var pitch_min = deg2rad(input.get("pitch_min") - 1)
	var pitch_max = deg2rad(input.get("pitch_max") + 1)
	var rotation = input.get_prop(PlayerInputs.CAMERA_ROTATION)
	
	# If out of bounds and not in free look, start pitch interpolation
	var free_look = state.get_skating_state() || (!state.get_prop(PP.DIVING) && !state.get_prop(PP.GROUNDED))
	var in_bounds = rotation.x > pitch_min && rotation.x < pitch_max
	if(!free_look && !in_bounds && lerp_pitch == LERP_MODE.NONE):
		if(state.get_diving_state() || state.get_sliding_state()):
			lerp_pitch = LERP_MODE.NEUTRAL
		else:
			# If not diving, unwind by a full rotation (makes the lerp take the long way round)
			if(rotation.x > 0.0):
				if(rotation.x < PI && state.get_action_state() == state.ACTION_STATE.CROUCHING):
					# Transition to back prone if pitch hasn't completed a half-rotation
					input.set("yaw_basis", rad2deg(input.get_prop(PlayerInputs.CAMERA_ROTATION).y))
					capsule_rotation.set("rot_forward", -camera_yaw.global_transform.basis.z)
					state.set_prop(PP.SLIDING, true)
					lerp_pitch = LERP_MODE.PITCH_MAX
				else:
					rotation.x -= TAU
					lerp_pitch = LERP_MODE.NEUTRAL
			elif(rotation.x < 0.0):
				rotation.x += TAU
				lerp_pitch = LERP_MODE.NEUTRAL
	
	# Wrap pitch, accounting for min/max (prevents multiple rolls on landing)
	if(rotation.x > TAU - pitch_max):
		rotation.x -= TAU
	if(rotation.x < -TAU - pitch_min):
		rotation.x += TAU
	
	if(lerp_pitch):
		var target = 0.0
		match(lerp_pitch):
			LERP_MODE.PITCH_MIN: target = pitch_min
			LERP_MODE.PITCH_MAX: target = pitch_max
		rotation.x = lerp(rotation.x, target, delta * recenter_speed)
		if(abs(target - rotation.x) < deg2rad(1.0)):
			lerp_pitch = LERP_MODE.NONE
	
	
	input.set("clamp_pitch", !free_look)
	input.set("lock_pitch", lerp_pitch)
	input.set_prop(PlayerInputs.CAMERA_ROTATION, rotation)
	
	camera_yaw.rotation.y = rotation.y
	camera_pitch.rotation.x = rotation.x
