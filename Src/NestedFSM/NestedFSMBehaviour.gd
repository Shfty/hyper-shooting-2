class_name NestedFSMBehavior
extends NestedFSMBase

const IS_BEHAVIOUR = true

func is_active():
	if(_parent_fsm != null):
		if("IS_FSM" in _parent_fsm):
			if(_parent_fsm.is_active()):
				return true
	return false
