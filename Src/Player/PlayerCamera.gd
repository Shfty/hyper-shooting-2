extends Node

export(float) var recenter_speed = 10

onready var player_state = get_node("../../PlayerState")
onready var player_fsm = get_node("../../PlayerFSM")
onready var camera_yaw: CameraYaw = get_node("../../CameraRigGlobal/CameraRig/ViewBob/CameraYaw")
onready var camera_pitch: CameraPitch = get_node("../../CameraRigGlobal/CameraRig/ViewBob/CameraYaw/CameraPitch")
onready var directional_rotation: DirectionalRotation = get_node("../../DirectionalRotation")

enum LERP_MODE {
	NONE,
	NEUTRAL,
	PITCH_MIN,
	PITCH_MAX
}

var lerp_pitch = LERP_MODE.NONE

func _physics_process(delta):
	var clamp_yaw = false
	var yaw_limit = 0.0
	var target_pitch_min = -89.0
	var target_pitch_max = 89.0
	
	match player_fsm.get_action_state():
		PlayerFSM.ACTION_STATE.BACK_PRONE:
			clamp_yaw = true
			yaw_limit = 80.0
			target_pitch_min = 0.0
			target_pitch_max = 179.0
		PlayerFSM.ACTION_STATE.FRONT_PRONE:
			clamp_yaw = true
			yaw_limit = 80.0
			target_pitch_min = 0.0
			target_pitch_max = 44.0
		PlayerFSM.ACTION_STATE.AIR_DIVE:
			clamp_yaw = true
			yaw_limit = 80.0
			target_pitch_min = -89.0
			target_pitch_max = 89.0
	
	camera_yaw.clamp_yaw = clamp_yaw
	camera_yaw.yaw_limit = yaw_limit
	camera_pitch.pitch_min = target_pitch_min
	camera_pitch.pitch_max = target_pitch_max
	
	var pitch_min = deg2rad(camera_pitch.pitch_min - 1)
	var pitch_max = deg2rad(camera_pitch.pitch_max + 1)
	
	var pitch = camera_pitch.get_pitch()
	
	# If out of bounds and not in free look, start pitch interpolation
	var free_look = player_fsm.get_skating_state() || (!player_state.get_diving() && !player_state.get_grounded())
	var in_bounds = pitch > pitch_min && pitch < pitch_max
	if(!free_look && !in_bounds && lerp_pitch == LERP_MODE.NONE):
		if(player_fsm.get_diving_state() || player_fsm.get_sliding_state()):
			lerp_pitch = LERP_MODE.NEUTRAL
		else:
			# If not diving, unwind by a full rotation (makes the lerp take the long way round)
			if(pitch > 0.0):
				if(pitch < PI && player_fsm.get_action_state() == player_fsm.ACTION_STATE.CROUCHING):
					# Transition to back prone if pitch hasn't completed a half-rotation
					camera_yaw.reset_yaw_basis()
					directional_rotation.set_rot_forward(-camera_yaw.global_transform.basis.z)
					player_state.set_prop(PP.SLIDING, true)
					lerp_pitch = LERP_MODE.PITCH_MAX
				else:
					pitch -= TAU
					lerp_pitch = LERP_MODE.NEUTRAL
			elif(pitch < 0.0):
				pitch += TAU
				lerp_pitch = LERP_MODE.NEUTRAL
	
	# Wrap pitch, accounting for min/max (prevents multiple rolls on landing)
	if(pitch > TAU - pitch_max):
		pitch -= TAU
	if(pitch < -TAU - pitch_min):
		pitch += TAU
	
	if(lerp_pitch):
		var target = 0.0
		match(lerp_pitch):
			LERP_MODE.PITCH_MIN: target = pitch_min
			LERP_MODE.PITCH_MAX: target = pitch_max
		pitch = lerp(pitch, target, delta * recenter_speed)
		if(abs(target - pitch) < deg2rad(1.0)):
			lerp_pitch = LERP_MODE.NONE
	
	camera_pitch.clamp_pitch = !free_look
	camera_pitch.lock_pitch = lerp_pitch
	camera_pitch.set_pitch(pitch)
