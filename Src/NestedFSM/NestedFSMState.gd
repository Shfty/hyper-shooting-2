class_name NestedFSMState
extends NestedFSMBase

const IS_FSM = true

onready var states = $States
onready var pre_behaviors = $PreBehaviors
onready var post_behaviors = $PostBehaviors

var active_state = null setget set_active_state, get_active_state

# Setters
func set_active_state(new_active_state):
	if("IS_FSM" in new_active_state && (active_state == null || get_active_state() != new_active_state)):
		active_state = weakref(new_active_state)
		var active_state_ref = active_state.get_ref()

# Getters
func get_active_state():
	if(active_state != null):
		return active_state.get_ref()
	return null

# State Interface
func is_active():
	if(self._parent_fsm == null):
		return true

	if(!self._parent_fsm.is_active()):
		return false

	return self._parent_fsm.get_active_state() == self

# State Events
func enter(from_state):
	print(name, " enter from ", from_state)

	for child in .get_children():
		if("IS_BEHAVIOUR" in child):
			child.enter(from_state)

	for child in pre_behaviors.get_children():
		if("IS_BEHAVIOUR" in child):
			child.enter(from_state)

	for child in post_behaviors.get_children():
		if("IS_BEHAVIOUR" in child):
			child.enter(from_state)

func exit(to_state):
	print(name, " exit to ", to_state)

	for child in .get_children():
		if("IS_BEHAVIOUR" in child):
			child.exit(to_state)

	for child in pre_behaviors.get_children():
		if("IS_BEHAVIOUR" in child):
			child.exit(to_state)

	for child in post_behaviors.get_children():
		if("IS_BEHAVIOUR" in child):
			child.exit(to_state)

# Utility
func change_to(path_string: String):
	var name = null
	var slash_index = path_string.find("/")
	if(slash_index > 0):
		name = path_string.substr(0, slash_index)
		path_string = path_string.substr(slash_index + 1, path_string.length())
	else:
		name = path_string
		path_string = ""

	# Switch to state if it exists
	var state = states.get_node_or_null(name)
	if(state != null):
		var prev_state = get_active_state()

		if(prev_state != state):
			if(prev_state):
				prev_state.exit(name)
			set_active_state(state)

		if(path_string == ""):
			state.enter(prev_state.name if prev_state else "")
			return state
		else:
			return state.change_to(path_string)

	return null
