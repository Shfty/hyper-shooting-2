extends KinematicBody

export(NodePath) var target_path
onready var target = Util.get_node_from_path(self, target_path)

export(Vector3) var target_offset = Vector3.UP

export(float) var lateral_slack_min = 2.0
export(float) var lateral_slack_max = 5.0

export(float) var vertical_slack = 1.0

export(float) var horizontal_angular_slack = 10.0
export(float) var vertical_angular_slack = 10.0

func _process(delta):
	var target_origin = target.global_transform.origin
	var self_origin = global_transform.origin
	var delta_pos = target_origin - self_origin + target_offset
	
	var delta_lateral = Vector3(delta_pos.x, 0.0, delta_pos.z)
	
	if(delta_lateral.length() > lateral_slack_max):
		move_and_slide(delta_lateral.normalized() * ((delta_lateral.length() - lateral_slack_max)) / delta)
	elif(delta_lateral.length() < lateral_slack_min):
		move_and_slide(delta_lateral.normalized() * ((delta_lateral.length() - lateral_slack_min)) / delta)

	var delta_vertical = Vector3(0.0, delta_pos.y, 0.0)
	
	if(delta_vertical.length() > vertical_slack):
		move_and_slide(delta_vertical.normalized() * ((delta_vertical.length() - vertical_slack)) / delta)
	
	var delta_yaw = acos(delta_lateral.normalized().dot(-global_transform.basis.z))
	delta_yaw *= sign(Vector3.UP.dot(-global_transform.basis.z.cross(delta_lateral)))
	print(delta_yaw)
	if(abs(delta_yaw) > deg2rad(horizontal_angular_slack)):
		rotation.y += (abs(delta_yaw) - deg2rad(horizontal_angular_slack)) * sign(delta_yaw)
