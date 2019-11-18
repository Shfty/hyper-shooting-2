extends Node

func bool_to_int(boolean, number):
	return number if boolean else 0

class NodeDependencies:
	var node_names: Array = []
	var node_insts: Dictionary = {}

	func _init(node_names: Array):
		self.node_names = node_names
	
	func ready(context: Node):
		for node_name in node_names:
			var node_inst = null
			print(context.get_children())
			if(context.name == node_name):
				node_inst = context
			else:
				node_inst = context.find_node(node_name)
			
			assert(node_inst != null)
			node_insts[node_name] = node_inst
	
	func get(node_name: String):
		return node_insts[node_name]
