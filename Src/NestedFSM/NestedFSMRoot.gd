class_name NestedFSMRoot
extends NestedFSMState

export(String) var active_state_path
export(Dictionary) var context

# @TODO:
# Centralize logic in FSM root
# Minimize state / behaviour logic, note tree should be a data model for scripts
# Remove state logic entirely? States as behavior groups
# Use an active state path to walk down the tree and activate/deactivate nodes as needed
# Create SVG icons to represent root, state and behavior
# Remove dependency on prefab pre/state/post nodes
# Use the set_process_* family of functions to control execution instead of calling custom recursive versions

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
	change_to(active_state_path);

func _process(delta):
	call_recursive_one_param_active(self, "process", delta)

func _physics_process(delta):
	call_recursive_one_param_active(self, "physics_process", delta)

func set_parent_fsm_recursive(node, prev_node):
	if("_parent_fsm" in node):
		node._parent_fsm = prev_node
	
	if("root_fsm" in node):
		node.root_fsm = self
	
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
