class_name ClampYawBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"

export(float) var yaw_limit = 0.0
var yaw_basis = 0.0

func enter():
	var player_state := get_context(player_state_key) as PlayerState
	yaw_basis = rad2deg(player_state.get_yaw())

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var yaw = player_state.get_yaw()
	yaw = clamp(yaw, deg2rad(yaw_basis - yaw_limit), deg2rad(yaw_basis + yaw_limit))
	player_state.set_yaw(yaw)
