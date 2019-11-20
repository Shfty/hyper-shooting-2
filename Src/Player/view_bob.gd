extends Node

var nodes = Util.NodeDependencies.new([
	PN.Controllers.BOB,
	PN.Spatial.CAMERA
])

export (float) var bob_magnitude = 2

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var bob = nodes.get(PN.Controllers.BOB)
	var camera = nodes.get(PN.Spatial.CAMERA)
	
	var bob_factor = bob.get("bob")
	var mod_bob = cos(bob_factor)
	camera.translation.y = (0.5 * bob_magnitude) + (mod_bob * bob_magnitude)
