class_name FrictionBehavior
extends NestedFSMBehavior

export(float) var stop_speed = 100.0
export(float) var friction = 6.0

func physics_process(delta):
	# Modify velocity
	var player_state = get_context_inst() as PlayerState
	var velocity = player_state.get_velocity()
	velocity = apply_friction(delta, velocity)
	player_state.set_velocity(velocity)

func apply_friction(delta: float, velocity: Vector3):
	var speed = velocity.length()
	if(speed < 1):
		velocity.x = 0
		velocity.z = 0
	
	var drop = 0
	if(stop_speed > 0):
		var control = stop_speed if speed < stop_speed else speed
		drop = control * friction * delta
	
	var new_speed = speed - drop
	if(new_speed < 0):
		new_speed = 0
	
	if(speed != 0):
		new_speed /= speed
	
	velocity.x *= new_speed
	velocity.z *= new_speed
	
	return velocity
