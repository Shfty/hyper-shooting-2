class_name CameraYaw
extends Spatial

onready var camera_pitch: CameraPitch = $CameraPitch

var clamp_yaw = false
var yaw_basis = 0.0
var yaw_limit = 90.0

func get_yaw():
	return rotation.y

func set_yaw(new_yaw):
	rotation.y = new_yaw

func reset_yaw_basis():
	yaw_basis = rad2deg(get_yaw())


func mouse_move_x(delta):
	# Yaw
	var yawSign = 1 if abs(camera_pitch.get_pitch()) >= PI * 0.5 else -1
	rotation.y += delta * yawSign
	
	if(clamp_yaw):
		rotation.y = clamp(rotation.y, deg2rad(yaw_basis - yaw_limit), deg2rad(yaw_basis + yaw_limit))