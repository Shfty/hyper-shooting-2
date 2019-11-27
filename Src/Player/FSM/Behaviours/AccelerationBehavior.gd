class_name AccelerationBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var kinematic_body_key = "kinematic_body"
export(String) var wish_vector_key = "wish_vector"

export(float) var move_speed = 12.2
export(float) var acceleration = 10.0

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	var kinematic_body := get_context(kinematic_body_key) as KinematicBody
	var wish_vector := get_context(wish_vector_key) as WishVector
	
	# Fetch wish vector
	var wish_vec = wish_vector.get_wish_vector(player_state.get_yaw())
	
	# Project onto wall if colliding
	var slide_count = kinematic_body.get_slide_count()
	if(kinematic_body.is_on_wall() && slide_count > 0):
		var collision = kinematic_body.get_slide_collision(0)
		var wall_normal = collision.normal
		var wall_perp = wall_normal.cross(Vector3.UP).normalized()
		var wish_sign = wish_vec.dot(wall_perp)
		wish_vec = wall_perp.normalized() * wish_sign
	
	# Modify velocity
	var velocity = player_state.get_velocity()
	velocity = apply_acceleration(delta, wish_vec, velocity)
	player_state.set_velocity(velocity)

func apply_acceleration(delta: float, wish_vec: Vector3, velocity: Vector3):
	var wish_speed = wish_vec.length() * move_speed
	var add_speed = wish_speed - velocity.dot(wish_vec)
	if(add_speed <= 0):
		return velocity
		
	var accel_speed = acceleration * delta * wish_speed
	if(accel_speed > add_speed):
		accel_speed = add_speed
		
	return velocity + accel_speed * wish_vec
