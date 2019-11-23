extends Node

onready var player_fsm: PlayerFSM = get_node("../../PlayerFSM")
onready var cylinder_height: CylinderHeight = get_node("../../CollisionShape/CylinderHeight")
onready var directional_rotation: DirectionalRotation = get_node("../../DirectionalRotation")

export var crouch_transition_speed: float = 15.0
export var rotate_transition_speed: float = 15.0
export var full_crouch_threshold = 1.0

const standing_height = 56
const standing_skating_height = 50
const crouching_height = 36

func _physics_process(delta):
	var target_height = standing_height
	var target_rotation = 0
	match(player_fsm.get_action_state()):
		player_fsm.ACTION_STATE.STANDING:
			target_height = standing_skating_height if player_fsm.get_skating_state() else standing_height
		player_fsm.ACTION_STATE.CROUCHING:
			target_height = crouching_height
		player_fsm.ACTION_STATE.FRONT_PRONE:
			target_height = standing_height
			target_rotation = 90
		player_fsm.ACTION_STATE.BACK_PRONE:
			target_height = standing_height
			target_rotation = -90
		player_fsm.ACTION_STATE.IN_AIR:
			target_height = standing_height
		player_fsm.ACTION_STATE.AIR_DIVE:
			target_height = standing_height
			target_rotation = 80
	
	cylinder_height.set_height(lerp(cylinder_height.height, target_height, delta * crouch_transition_speed))
	directional_rotation.set_rot_angle(lerp(directional_rotation.rot_angle, target_rotation, delta * rotate_transition_speed))

func is_fully_crouched():
	return cylinder_height.height < crouching_height + full_crouch_threshold
