tool

extends Path

export (Array, Vector3) var points = [] setget set_points
export (float) var point_scale = 10.0 setget set_point_scale

# Getters
func get_point_children():
	var point_children = []
	for child in get_children():
		if(child is Position3D):
			point_children.append(child)
	return point_children

# Setters
func set_points(new_points):
	if(points != new_points):
		points = new_points
		init_points()

func set_point_scale(new_point_scale):
	if(point_scale != new_point_scale):
		point_scale = new_point_scale

		for child in get_point_children():
			child.scale = Vector3(point_scale, point_scale, point_scale)

# Business Logic
func _ready():
	set_process(Engine.is_editor_hint())

func init_points():
	clear_path_points()
	clear_child_points()

	add_path_point(Vector3.ZERO)
	for point in points:
		add_path_point(point)
		add_child_point(point)

func clear_path_points():
	curve.clear_points()

func clear_child_points():
	# clear out any leftover points
	for child in get_point_children():
		remove_child(child)
		child.queue_free()

func add_path_point(point):
	curve.add_point(point)

func add_child_point(point):
	var node = Position3D.new()
	node.translation = point
	node.scale = Vector3(point_scale, point_scale, point_scale)
	add_child(node)

	# Add to edited scene
	if(is_inside_tree()):
		var tree = get_tree()
		if(tree != null):
			var edited_scene_root = tree.get_edited_scene_root()
			if(edited_scene_root != null):
				node.set_owner(edited_scene_root)

func init_curve_points():
	for idx in range(0, curve.get_point_count()):
		curve.remove_point(idx)

func _process(delta):
	while(get_point_children().size() < points.size()):
		points.remove(points.size() - 1)
		curve.remove_point(curve.get_point_count() - 1)

	while(get_point_children().size() > points.size()):
		points.append(Vector3.ZERO)
		curve.add_point(Vector3.ZERO)

	var idx = 0
	for child in get_point_children():
		points[idx] = child.translation
		curve.set_point_position(idx + 1, child.translation)
		idx += 1
