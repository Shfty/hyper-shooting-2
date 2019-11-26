class_name NestedFSMBase
extends Node

const FSM_BASE = true

# warning-ignore:unused_class_variable
export(NodePath) var context
var context_inst = null setget set_context_inst, get_context_inst

# warning-ignore:unused_class_variable
var parent_fsm = null

func set_context_inst(new_context_inst):
	if(context_inst == null):
		context_inst = new_context_inst

func get_context_inst():
	return context_inst

# Events
func is_active():
	return false

func start():
	pass

func enter():
	pass

# warning-ignore:unused_argument
func exit(next_state):
	pass

# warning-ignore:unused_argument
func process(delta):
	pass
	
# warning-ignore:unused_argument
func physics_process(delta):
	pass

