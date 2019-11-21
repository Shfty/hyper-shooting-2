extends StaticBody

export(NodePath) var path_follow
export(int) var target_point = 0 setget set_target_point
export(float) var move_speed = 200.0

var path_follow_inst: PathFollow = null
var path: Path = null

var path_lengths: Array

# Setters
func set_target_point(new_target_point):
	print("set_target_point")
	if(target_point != new_target_point):
		target_point = new_target_point

# Business Logic
func _ready():
	if(!path_follow.is_empty()):
		path_follow_inst = get_node(path_follow)
		path = path_follow_inst.get_parent()
		if(!path is Path):
			print("Warning: PathFollow parent must be a path")
			return
		
		var curve = path.get_curve()
		var prev_point = null
		var length = 0
		for idx in range(0, curve.get_point_count()):
			if(prev_point != null):
				length += (curve.get_point_position(idx) - prev_point).length()
			path_lengths.append(length)
			prev_point = curve.get_point_position(idx)

func _physics_process(delta):
	if(path_follow_inst != null && path != null):
		var target_dist = path_lengths[target_point]
		var current_dist = path_follow_inst.offset
		var delta_dist = target_dist - current_dist
		var delta_length = abs(delta_dist)
		
		if(delta_length > 0.0):
			var prev_translation = path_follow_inst.translation
			path_follow_inst.offset += sign(delta_dist) * min(move_speed * delta, delta_length)
			translation = path_follow_inst.translation
			constant_linear_velocity = prev_translation - translation
		else:
			constant_linear_velocity = Vector3.ZERO
	