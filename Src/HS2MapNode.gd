tool
class_name HS2MapNode
extends QuakeMapNode

func spawn_entity_node(classname):
	var node = null

	match classname:
		"info_player_start":
			node = load("res://Scenes/Player/Player.tscn").instance()
		_:
			node = .spawn_entity_node(classname)

	return node
