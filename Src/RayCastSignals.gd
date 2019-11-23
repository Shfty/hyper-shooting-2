class_name RayCastSignals
extends RayCast

var colliding: bool = false
var prev_colliding: bool = false

signal colliding_changed(colliding)
signal collision_start
signal collision_end

func _physics_process(delta):
	colliding = is_colliding()
	
	if(colliding != prev_colliding):
		emit_signal("colliding_changed", colliding)
		if(colliding && !prev_colliding):
			emit_signal("collision_start")
		elif(!colliding && prev_colliding):
			emit_signal("collision_end")
	
	prev_colliding = colliding
