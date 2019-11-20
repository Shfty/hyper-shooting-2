extends Node

var nodes = Util.NodeDependencies.new([
	PN.Models.INPUT,
	PN.Models.STATE,
	PN.Controllers.CAPSULE_HEIGHT,
	PN.Controllers.CAPSULE_ROTATION
])

export var crouch_transition_speed = 15
export var rotate_transition_speed = 15
export var full_crouch_threshold = 2.5

const standing_height = 56
const standing_skating_height = 46
const crouching_height = 36

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var input = nodes.get(PN.Models.INPUT)
	var state = nodes.get(PN.Models.STATE)
	var capsule_height = nodes.get(PN.Controllers.CAPSULE_HEIGHT)
	var capsule_rotation = nodes.get(PN.Controllers.CAPSULE_ROTATION)
	
	var target_height = standing_height
	var target_rotation = 0
	match(state.get_action_state()):
		state.ACTION_STATE.STANDING:
			target_height = standing_skating_height if state.get_skating_state() else standing_height
		state.ACTION_STATE.CROUCHING:
			target_height = crouching_height
		state.ACTION_STATE.FRONT_PRONE:
			target_height = standing_height
			target_rotation = 90
		state.ACTION_STATE.BACK_PRONE:
			target_height = standing_height
			target_rotation = -90
		state.ACTION_STATE.IN_AIR:
			target_height = standing_height
		state.ACTION_STATE.AIR_DIVE:
			target_height = standing_height
			target_rotation = 80
	
	capsule_height.set("height", lerp(capsule_height.get("height"), target_height, delta * crouch_transition_speed))
	capsule_rotation.set("rot_angle", lerp(capsule_rotation.get("rot_angle"), target_rotation, delta * rotate_transition_speed))

func is_fully_crouched():
	var capsule_height = nodes.get(PN.Controllers.CAPSULE_HEIGHT)
	return capsule_height.get("height") < crouching_height + full_crouch_threshold
