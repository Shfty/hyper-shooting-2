extends Node

var nodes = Util.NodeDependencies.new([
	PN.Controllers.BOB,
	PN.Spatial.WEAPON
])

export (float) var bob_magnitude = 4

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var bob = nodes.get(PN.Controllers.BOB)
	var weapon = nodes.get(PN.Spatial.WEAPON)
	
	var bob_factor = bob.get("bob")
	var mod_bob = cos(bob_factor + PI * 1.5)
	
	if(mod_bob > 0):
		weapon.translation.z = mod_bob * bob_magnitude
	else:
		weapon.translation.z = mod_bob * bob_magnitude * 0.2
