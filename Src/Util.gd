class_name Util

static func add_child_editor(obj, child):
	obj.add_child(child)
	if(obj.is_inside_tree()):
		var tree = obj.get_tree()
		if(tree != null):
			var edited_scene_root = tree.get_edited_scene_root()
			if(edited_scene_root != null):
				child.set_owner(edited_scene_root)
	return child

static func get_node_from_path(context: Node, node_path: NodePath):
	return context.get_node(node_path) if !node_path.is_empty() else null
