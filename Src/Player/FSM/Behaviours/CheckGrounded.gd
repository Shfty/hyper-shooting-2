extends NestedFSMBehavior

export(NodePath) var kinematic_body
var kinematic_body_inst = null

func _ready():
	if(!kinematic_body.is_empty()):
		kinematic_body_inst = .get_node(kinematic_body)

# warning-ignore:unused_argument
func physics_process(delta):
	if(kinematic_body_inst == null):
		return
	
	var player_state = .get_context_inst() as PlayerState
	player_state.set_grounded(kinematic_body_inst.is_on_floor())
