class_name NestedFSMRoot
extends NestedFSMState

export(Dictionary) var context

# Overrides
func _ready():
	# Initialize FSM parents
	set_parent_fsm_recursive(self, null)
	
	# Prepare context
	var new_context_inst = {}
	for key in context:
		var val = context[key]
		if(val is NodePath):
			new_context_inst[key] = get_node(val)
		else:
			new_context_inst[key] = val
	
	call_recursive_one_param(self, "set_context_inst", new_context_inst)
	
	# Start
	call_recursive(self, "start")

func _process(delta):
	call_recursive_one_param_active(self, "process", delta)

func _physics_process(delta):
	call_recursive_one_param_active(self, "physics_process", delta)

func set_parent_fsm_recursive(node, prev_node):
	if("parent_fsm" in node):
		node.parent_fsm = prev_node
	
	if("IS_FSM" in node):
		prev_node = node
	
	for child in node.get_children():
		set_parent_fsm_recursive(child, prev_node)

func call_recursive(node, function_name):
	if(node.has_method(function_name)):
		node.call(function_name)
	
	for child in node.get_children():
		call_recursive(child, function_name)

func call_recursive_one_param(node, function_name, param):
	if(node.has_method(function_name)):
		node.call(function_name, param)
	
	for child in node.get_children():
		call_recursive_one_param(child, function_name, param)

func call_recursive_one_param_active(node, function_name, param):
	if(node.has_method(function_name)):
		if(node.has_method("is_active")):
			if(node.is_active()):
				node.call(function_name, param)
	
	for child in node.get_children():
		call_recursive_one_param_active(child, function_name, param)

func is_active():
	return true
