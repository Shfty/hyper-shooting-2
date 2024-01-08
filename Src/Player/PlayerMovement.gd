class_name PlayerMovement
extends Node

onready var player_state: PlayerState = null

export(float) var slide_skate_threshold = 500.0
var slide_limit = false

# @TODO: Prone rotation (rotate toward velocity, align to ground)
# @TODO: Fix prone collision (rotate to align to wall)
# @TODO: Go to full crouch, rotate, then uncrouch on prone recovery
# @TODO: Fix spline curve updates in editor, currently overpopulating data
# @TODO: Add reticle
# @TODO: Fire at reticle instead of weapon forward

# Functions
func move_ground(delta: float, wish_vec: Vector3, velocity: Vector3):
	if(player_state == null):
		return
	
	var skating = player_state.get_skating()
	var prone = player_state.get_stance() == PlayerState.Stance.PRONE
	
	var back_prone = player_state.is_back_prone()
	
	if(prone && slide_limit && velocity.length() < slide_skate_threshold):
		slide_limit = false
	
	if(skating):
		var is_sliding_limited = prone && back_prone && slide_limit == true
		if(!is_sliding_limited):
			pass
			#return move_air(delta, wish_vec, velocity)
	