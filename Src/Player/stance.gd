extends Node

const STATE = "StateModel"
const CAPSULE_HEIGHT = "CapsuleHeightController"
var nodes = Util.NodeDependencies.new([
	STATE,
	CAPSULE_HEIGHT
])

# @TODO: Fix bounce on uncrouch
export var crouch_transition_speed = 15

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var state = nodes.get(STATE)
	var capsule_height = nodes.get(CAPSULE_HEIGHT)
	
	var target_height = 56
	if(state.get_grounded()):
		if(state.get_crouching()):
			target_height = 30
		elif(state.get_skating()):
			target_height = 46
	
	capsule_height.set("height", lerp(capsule_height.get("height"), target_height, delta * crouch_transition_speed))
