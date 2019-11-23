class_name ViewBob
extends Spatial

export (float) var bob_magnitude = 2
	
func set_bob(bob: float):
	var mod_bob = cos(bob)
	translation.y = (0.5 * bob_magnitude) + (mod_bob * bob_magnitude)
