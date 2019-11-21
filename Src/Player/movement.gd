extends Node

var nodes = Util.NodeDependencies.new([
	PN.Models.INPUT,
	PN.Models.STATE,
	PN.Spatial.KINEMATIC_BODY,
	PN.Spatial.CAMERA_YAW,
	PN.Spatial.UNCROUCH_RAYCAST,
	PN.Controllers.CAPSULE_ROTATION,
	PN.Controllers.STANCE
])

var input = null
var state = null

export(float) var move_speed = 320.0
export(float) var crouch_speed = 200.0
export(float) var stop_speed = 100.0

export(float) var gravity = 800.0
export(float) var jump_impulse = 270

export(float) var slide_impulse = 1200.0
export(float) var slide_skate_threshold = 500.0
export(float) var slide_stop_threshold = 150.0

export(float) var dive_impulse = 400.0
export(float) var dive_stop_threshold = 50.0

export(float) var ground_friction = 6.0
export(float) var prone_friction = 3.0
export(float) var max_slope_angle = 89.0

export(float) var ground_accelerate = 10.0
export(float) var prone_accelerate = 0.0
export(float) var air_accelerate = 1.5

export(float) var ground_trace_distance = 15.0

# @TODO: Align wish vector to slopes
# @TODO: Prone rotation
# @TODO: Fix prone collision
# @TODO: Trigger back prone if over-aiming backward during a jump
# @TODO: Proper dodge roll interpolation
# @TODO: Go to full crouch, rotate, then uncrouch on prone recovery
# @TODO: Figure out solution to height difference between crouch / prone

# Functions
func _ready():
	nodes.ready(owner)
	input = nodes.get(PN.Models.INPUT)
	state = nodes.get(PN.Models.STATE)

func _physics_process(delta):
	# Fetch wish vector
	var wish_vector = input.get_prop(PlayerInputs.WISH_VECTOR)
	
	# Rotate by camera yaw
	var camera_yaw = nodes.get(PN.Spatial.CAMERA_YAW)
	wish_vector = wish_vector.rotated(
		Vector3(0, 1, 0), camera_yaw.global_transform.basis.get_euler().y
	)
	
	# Project onto wall if colliding
	var body = nodes.get(PN.Spatial.KINEMATIC_BODY)
	var slide_count = body.get_slide_count()
	if(body.is_on_wall() && slide_count > 0):
		var collision = body.get_slide_collision(0)
		var wall_normal = collision.normal
		var wall_perp = wall_normal.cross(Vector3.UP).normalized()
		var wish_sign = wish_vector.dot(wall_perp)
		
		var prev_wish_vector = wish_vector
		wish_vector = wall_perp.normalized() * wish_sign
	
	# Curry ground and move functions
	var move_ground = FP.curry(self, "move_ground", [delta, wish_vector])
	var move_air = FP.curry(self, "move_air", [delta, wish_vector])
	
	# Process velocity
	state.set_prop(
		PP.VELOCITY,
		FP.pipe(state.get_prop(PP.VELOCITY), [
			move_ground if nodes.get(PN.Spatial.KINEMATIC_BODY).is_on_floor() else move_air,
			FP.curry(self, "add_gravity", [delta]),
			FP.curry(self, "apply_velocity", [delta])
		])
	)
	
func apply_velocity(delta, velocity):
	var body = nodes.get(PN.Spatial.KINEMATIC_BODY)
	body.global_transform.origin += body.get_floor_velocity()
	
	var skate = state.get_skating_state()
	var ground_vector = Vector3.DOWN * ground_trace_distance if state.get_prop(PP.GROUNDED) && !skate else Vector3.ZERO
	velocity = body.move_and_slide_with_snap(velocity, ground_vector, Vector3.UP, !skate, 4, deg2rad(max_slope_angle))
	return velocity

func add_gravity(delta: float, velocity: Vector3):
	if(!nodes.get(PN.Spatial.KINEMATIC_BODY).is_on_floor()):
		return velocity - Vector3(0, gravity * delta, 0)
	return velocity

func move(delta: float, wish_vec: Vector3, grounded: bool, friction: float, speed_cap: float, accelerate: float, velocity: Vector3):
	velocity = friction(delta, grounded, ground_friction, velocity)
	var wish_speed = wish_vec.length() * speed_cap
	return accelerate(delta, wish_vec, wish_speed, accelerate, velocity)

var slide_limit = false

func move_ground(delta: float, wish_vec: Vector3, velocity: Vector3):
	var stance = nodes.get(PN.Controllers.STANCE)
	var capsule_rotation = nodes.get(PN.Controllers.CAPSULE_ROTATION)
	
	if(state.get_diving_state() && !state.get_skating_state()):
		if(state.get_prop(PP.VELOCITY).length() < dive_stop_threshold  && !input.get_prop(PlayerInputs.CROUCH)):
			state.set_prop(PP.DIVING, false)
			input.set_prop(PlayerInputs.JUMP, false)
	
	if(state.get_sliding_state() && !state.get_skating_state()):
		if(state.get_prop(PP.VELOCITY).length() < slide_stop_threshold && !input.get_prop(PlayerInputs.CROUCH)):
			state.set_prop(PP.SLIDING, false)
			input.set_prop(PlayerInputs.JUMP, false)

	if(input.get_prop(PlayerInputs.JUMP)):
		if(state.get_sliding_state()):
			if(state.get_prop(PP.VELOCITY).length() < slide_stop_threshold || state.get_skating_state()):
				state.set_prop(PP.SLIDING, false)
				input.set_prop(PlayerInputs.JUMP, false)
		elif(state.get_diving_state()):
			if(state.get_prop(PP.GROUNDED)):
				state.set_prop(PP.DIVING, false)
				input.set_prop(PlayerInputs.JUMP, false)
		else:
			if(input.get_prop(PlayerInputs.DIVE)):
				state.set_prop(PP.DIVING, true)
				input.set_prop(PlayerInputs.JUMP, false)
				capsule_rotation.set("rot_forward", wish_vec)
				input.set("yaw_basis", rad2deg(input.get_prop(PlayerInputs.CAMERA_ROTATION).y))
				
				if(!state.get_skating_state()):
					velocity = wish_vec.normalized() * dive_impulse
					velocity.y = jump_impulse
					return move_air(delta, wish_vec, velocity)
			else:
				if(state.get_prop(PP.SLIDING)):
					state.set_prop(PP.SLIDING, false)
					if(velocity.length() > slide_skate_threshold):
						velocity = velocity.normalized() * slide_skate_threshold
			
				input.set_prop(PlayerInputs.JUMP, false)
				velocity.y = jump_impulse
				return move_air(delta, wish_vec, velocity)
	
	if(input.get_prop(PlayerInputs.SLIDE) && state.get_action_state() == state.ACTION_STATE.CROUCHING && !stance.is_fully_crouched()):
		state.set_prop(PP.SLIDING, true)
		capsule_rotation.set("rot_forward", wish_vec)
		input.set("yaw_basis", rad2deg(input.get_prop(PlayerInputs.CAMERA_ROTATION).y))
		if(!state.get_skating_state()):
			slide_limit = true
			velocity = wish_vec * slide_impulse
	
	state.set_prop(PP.GROUNDED, true)
	
	if(state.get_sliding_state() && slide_limit && velocity.length() < slide_skate_threshold):
		slide_limit = false
	
	if(state.get_skating_state()):
		var is_sliding_limited = state.get_sliding_state() && slide_limit == true
		if(!is_sliding_limited):
			return move_air(delta, wish_vec, velocity)
	
	var is_prone = state.get_action_state() == state.ACTION_STATE.BACK_PRONE || state.get_action_state() == state.ACTION_STATE.FRONT_PRONE
	var friction = prone_friction if is_prone else ground_friction
	var speed_cap = crouch_speed if state.get_action_state() == state.ACTION_STATE.CROUCHING else move_speed
	var accelerate = prone_accelerate if is_prone else ground_accelerate
	
	return move(delta, wish_vec, true, friction, speed_cap, accelerate, velocity)

func move_air(delta: float, wish_vec: Vector3, velocity: Vector3):
	if(!input.get_prop(PlayerInputs.SKATE)):
		state.set_prop(PP.GROUNDED, false)
	return move(delta, wish_vec, false, 0, move_speed, air_accelerate, velocity)

func friction(delta: float, grounded: bool, friction: float, velocity: Vector3):
	var speed = velocity.length()
	if(speed < 1):
		velocity.x = 0
		velocity.z = 0
	
	var drop = 0
	if(grounded):
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

func accelerate(delta: float, wish_dir: Vector3, wish_speed: float, accel: float, velocity: Vector3):
	var add_speed = wish_speed - velocity.dot(wish_dir)
	if(add_speed <= 0):
		return velocity
		
	var accel_speed = accel * delta * wish_speed
	if(accel_speed > add_speed):
		accel_speed = add_speed
		
	return velocity + accel_speed * wish_dir
