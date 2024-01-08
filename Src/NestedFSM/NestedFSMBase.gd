class_name NestedFSMBase
extends Node

const FSM_BASE = true

var context_inst: Dictionary = {} setget set_context_inst

# warning-ignore:unused_class_variable
var root_fsm = null
# warning-ignore:unused_class_variable
var _parent_fsm = null

func set_context_inst(new_context_inst) -> void:
	if(context_inst != new_context_inst):
		context_inst = new_context_inst

func get_context(key):
	return context_inst[key]

# Events
func is_active() -> bool:
	return false

func enter(from_state: String) -> void:
	pass

func exit(to_state: String) -> void:
	pass

func process(delta: float) -> void:
	pass
	
func physics_process(delta: float) -> void:
	pass
