extends Node

export(NodePath) var from_node
export(String) var from_signal

export(NodePath) var to_node
export(String) var to_method

export(Array) var binds

func _ready():
	var from_node_inst = get_node(from_node)
	var to_node_inst = get_node(to_node)
	from_node_inst.connect(from_signal, to_node_inst, to_method, binds)
