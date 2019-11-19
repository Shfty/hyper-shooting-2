extends Node

const STATE = "StateModel"
var nodes = Util.NodeDependencies.new([
	STATE
])

export (float) var bob_frequency = 0.03
export (float) var lerp_rate = 8

export (float) var bob = 0.0

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var state = nodes.get(STATE)
	
	var vel = state.get("velocity")
	var skate = state.get("skating")
	
	if(state.get("grounded") && !skate && vel.length() > 1):
		bob += vel.length() * delta * bob_frequency
	else:
		if(bob <= PI):
			bob = lerp(bob, 0, delta * lerp_rate)
		else:
			bob = lerp(bob, TAU, delta * lerp_rate)
		
	if(bob >= TAU):
		bob = 0

