class_name NestedFSMState
extends NestedFSMBase

const IS_FSM = true

onready var states = $States
onready var pre_behaviors = $PreBehaviors
onready var post_behaviors = $PostBehaviors

var active_state = null setget set_active_state, get_active_state

signal active_state_changed(active_state)

# Setters
func set_active_state(new_active_state):
	if("IS_FSM" in new_active_state && (active_state == null || active_state.get_ref() != new_active_state)):
		active_state = weakref(new_active_state)
		var active_state_ref = active_state.get_ref()
		
		emit_signal("active_state_changed", active_state_ref.name)

# Getters
func get_active_state():
	if(active_state != null):
		return active_state.get_ref()
	return null

# State Interface
func is_active():
	if(self.parent_fsm == null):
		return true
	
	if(!self.parent_fsm.is_active()):
		return false
		
	return self.parent_fsm.get_active_state() == self

func start():
	if(is_active()):
		var default_state = self.get_default_state()
		if(default_state):
			self.change_to(default_state)

# FSM Interface
func change_to(new_state: String, enter: bool = true):
	# Switch to state if it exists
	var state = states.find_node(new_state, false)
	if(state != null):
		set_active_state(state)
		if(enter):
			get_active_state().enter()

func current_state():
	if(active_state != null):
		var active_state_ref = active_state.get_ref()
		if(active_state_ref != null):
			return active_state_ref.name
	return null

# State Events
func get_default_state():
	return null
	
func enter_active_state():
	var active_state_ref = get_active_state()
	if(active_state_ref != null):
		active_state_ref.enter()

func enter():
	print(self.name, " enter")
	
	var default_state = get_default_state()
	if(default_state != null):
		change_to(default_state)
	else:
		enter_active_state()
		
	for child in .get_children():
		if("IS_BEHAVIOUR" in child):
			child.enter()
		
	for child in pre_behaviors.get_children():
		if("IS_BEHAVIOUR" in child):
			child.enter()
		
	for child in post_behaviors.get_children():
		if("IS_BEHAVIOUR" in child):
			child.enter()

func exit(next_state):
	if(self.parent_fsm != null):
		self.parent_fsm.change_to(next_state)

