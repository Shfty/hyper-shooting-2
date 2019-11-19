extends Node

const MOVEMENT = "MovementController"
var nodes = Util.NodeDependencies.new([
	MOVEMENT
])

export (float) var bob_frequency = 0.03
export (float) var lerp_rate = 8

export (float) var bob = 0.0

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var movement = nodes.get(MOVEMENT)
	
	var vel = movement.get("velocity")
	var skate = movement.get("skating")
	
	if(movement.get("grounded") && !skate && vel.length() > 1):
		bob += vel.length() * delta * bob_frequency
	else:
		if(bob <= PI):
			bob = lerp(bob, 0, delta * lerp_rate)
		else:
			bob = lerp(bob, TAU, delta * lerp_rate)
		
	if(bob >= TAU):
		bob = 0

