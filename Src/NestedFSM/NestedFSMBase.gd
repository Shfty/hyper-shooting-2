class_name NestedFSMBase
extends Node

const FSM_BASE = true

var context_inst: Dictionary = {} setget set_context_inst

# warning-ignore:unused_class_variable
var parent_fsm = null

func set_context_inst(new_context_inst):
	if(context_inst != new_context_inst):
		context_inst = new_context_inst

func get_context(key):
	return context_inst[key]

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

