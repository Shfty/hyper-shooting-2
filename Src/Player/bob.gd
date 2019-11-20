extends Node

var nodes = Util.NodeDependencies.new([
	PN.Models.INPUT,
	PN.Models.STATE
])

export (float) var bob_frequency = 0.03
export (float) var lerp_rate = 8

export (float) var bob = 0.0

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var input = nodes.get(PN.Models.INPUT)
	var state = nodes.get(PN.Models.STATE)
	
	var vel = state.get_prop(PP.VELOCITY)
	var grounded = state.get_prop(PP.GROUNDED)
	var skate = input.get_prop(PlayerInputs.SKATE)
	
	if(grounded && !skate && vel.length() > 1):
		bob += vel.length() * delta * bob_frequency
	else:
		if(bob <= PI):
			bob = lerp(bob, 0, delta * lerp_rate)
		else:
			bob = lerp(bob, TAU, delta * lerp_rate)
		
	if(bob >= TAU):
		bob = 0

