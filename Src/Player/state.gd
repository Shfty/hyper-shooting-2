extends Model

var nodes = Util.NodeDependencies.new([
	PN.Models.INPUT
])

enum ACTION_STATE {
	STANDING,
	CROUCHING,
	FRONT_PRONE,
	BACK_PRONE,
	IN_AIR,
	AIR_DIVE,
	TUCK_ROLL,
	WALL_SLIDE
}

func _ready():
	nodes.ready(owner)
	
	self.properties = {
		PP.VELOCITY: Vector3.ZERO,
		PP.GROUNDED: true,
		PP.SLIDING: false,
		PP.DIVING: false
	}

func get_action_state():
	var input = nodes.get(PN.Models.INPUT)
	
	if(get_prop(PP.GROUNDED)):
		if(get_prop(PP.SLIDING)):
			return ACTION_STATE.BACK_PRONE
		if(get_prop(PP.DIVING)):
			return ACTION_STATE.FRONT_PRONE
		if(input.get_prop(PlayerInputs.CROUCH)):
			return ACTION_STATE.CROUCHING
		return ACTION_STATE.STANDING
	else:
		if(get_prop(PP.DIVING)):
			return ACTION_STATE.AIR_DIVE
		return ACTION_STATE.IN_AIR

func get_skating_state():
	var input = nodes.get(PN.Models.INPUT)
	return get_prop(PP.GROUNDED) && input.get_prop(PlayerInputs.SKATE)

func get_sliding_state():
	return get_prop(PP.SLIDING)

func get_diving_state():
	return get_prop(PP.DIVING)
