class_name LeanRoll
extends Spatial

export(float) var lean_factor = 0.01
export(float) var max_lean = 2.5

func moved(delta, delta_move):
	var velocity = delta_move / delta
	var lean = velocity.dot(-get_global_transform().basis.x) * lean_factor
	lean = clamp(lean, -max_lean, max_lean)
	rotation.z = deg2rad(lean)
