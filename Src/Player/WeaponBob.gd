class_name WeaponBob
extends Spatial

export (float) var bob_magnitude = 4

func set_bob(bob):
	var mod_bob = cos(bob + PI * 1.5)
	
	if(mod_bob > 0):
		translation.z = mod_bob * bob_magnitude
	else:
		translation.z = mod_bob * bob_magnitude * 0.2
