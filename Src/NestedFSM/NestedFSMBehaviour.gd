class_name NestedFSMBehavior
extends NestedFSMBase

const IS_BEHAVIOUR = true

func is_active():
	if(parent_fsm != null):
		if("IS_FSM" in parent_fsm):
			if(parent_fsm.is_active()):
				return true
	return false
