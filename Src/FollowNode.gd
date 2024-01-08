class_name FollowNode
extends KinematicBody

export(NodePath) var target_path
onready var target = Util.get_node_from_path(self, target_path)

export(Vector3) var target_offset = Vector3.ZERO

export(float) var lateral_slack_min = 2.0
export(float) var lateral_slack_max = 5.0

export(float) var vertical_slack = 2.0

export(float) var yaw_slack = 10.0
export(float) var pitch_slack = 10.0

onready var yaw_spatial = $Yaw
onready var pitch_spatial = $Yaw/Pitch

func _physics_process(delta):
	var target_origin = target.global_transform.origin
	var self_origin = global_transform.origin - target_offset
	var delta_pos = target_origin - self_origin
	
	move_xz(delta, delta_pos)
	move_y(delta, delta_pos)
	yaw(delta_pos)
	pitch(delta_pos)

func move_xz(delta, delta_pos):
	var delta_lateral = Vector3(delta_pos.x, 0.0, delta_pos.z)
	
	if(delta_lateral.length() > lateral_slack_max):
		move_and_slide(delta_lateral.normalized() * ((delta_lateral.length() - lateral_slack_max)) / delta)
	elif(delta_lateral.length() < lateral_slack_min):
		move_and_slide(delta_lateral.normalized() * ((delta_lateral.length() - lateral_slack_min)) / delta)

func move_y(delta, delta_pos):
	var delta_vertical = Vector3(0.0, delta_pos.y, 0.0)
	
	if(delta_vertical.length() > vertical_slack):
		move_and_slide(delta_vertical.normalized() * ((delta_vertical.length() - vertical_slack)) / delta)

func yaw(delta_pos):
	var yaw = yaw_spatial.rotation.y
	
	var yaw_forward = -yaw_spatial.global_transform.basis.z
	var lateral_delta = Vector3(delta_pos.x, 0.0, delta_pos.z)
	var forward_dot_delta = yaw_forward.dot(lateral_delta.normalized())
	
	var delta_yaw = acos(forward_dot_delta)
	delta_yaw *= sign(Vector3.UP.dot(yaw_forward.cross(lateral_delta.normalized())))
	
	var slack_rad = deg2rad(yaw_slack)
	if(abs(delta_yaw) > slack_rad):
		yaw += (abs(delta_yaw) - slack_rad) * sign(delta_yaw)
	
	yaw_spatial.rotation.y = yaw

func pitch(delta_pos):
	var pitch = pitch_spatial.rotation.x
	
	var delta_dir = delta_pos.normalized()
	var delta_dir_lateral = Vector3(delta_dir.x, 0.0, delta_dir.z).normalized()
	
	var dot = delta_dir.dot(delta_dir_lateral)
	var rad = acos(dot)
	rad *= sign(delta_dir.y)
	
	var delta_pitch = rad - pitch
	
	var slack_rad = deg2rad(pitch_slack)
	if(abs(delta_pitch) > slack_rad):
		pitch += (abs(delta_pitch) - slack_rad) * sign(delta_pitch)
	
	pitch_spatial.rotation.x = pitch
	
