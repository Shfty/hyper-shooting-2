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

export(float) var slide_impulse = 1200.0
export(float) var slide_skate_threshold = 450.0
export(float) var slide_stop_threshold = 150.0
export(float) var dive_stop_threshold = 50.0

export(float) var ground_friction = 6.0
export(float) var prone_friction = 3.0
export(float) var max_slope_angle = 65.0

export(float) var ground_accelerate = 10.0
export(float) var prone_accelerate = 0.0
export(float) var air_accelerate = 1.5

export(float) var jump_velocity = 270

# @TODO: Fix prone collision
# @TODO: Prevent aerial movement unlock from applying during dives
# @TODO: Trigger back prone if over-aiming backward during a jump
# @TODO: Proper dodge roll interpolation
# @TODO: Align wish vector to slopes
# @TODO: Fix velocity loss on half pipes
# @TODO: Prone rotation
# @TODO: Go to full crouch, rotate, then uncrouch on prone recovery
# @TODO: Figure out solution to height difference between crouch / prone
# @TODO: Fix broken crouch test CSG

# Functions
func _ready():
	nodes.ready(owner)
	input = nodes.get(PN.Models.INPUT)
	state = nodes.get(PN.Models.STATE)

func _physics_process(delta):
	var wish_vector = input.get_prop(PlayerInputs.WISH_VECTOR).rotated(
		Vector3(0, 1, 0), input.get_prop(PlayerInputs.CAMERA_ROTATION).y
	)
	
	var move_ground = FP.curry(self, "move_ground", [delta, wish_vector])
	var move_air = FP.curry(self, "move_air", [delta, wish_vector])
	
	state.set_prop(
		PP.VELOCITY,
		FP.pipe(state.get_prop(PP.VELOCITY), [
			move_ground if nodes.get(PN.Spatial.KINEMATIC_BODY).is_on_floor() else move_air,
			FP.curry(self, "add_gravity", [delta]),
			FP.curry(self, "apply_velocity", [])
		])
	)

func apply_velocity(velocity):
	return nodes.get(PN.Spatial.KINEMATIC_BODY).move_and_slide_with_snap(velocity, Vector3.DOWN, Vector3.UP, !input.get_prop(PlayerInputs.SKATE), 4, deg2rad(max_slope_angle))

func add_gravity(delta: float, velocity: Vector3):
	return velocity - Vector3(0, gravity * delta, 0)

func move(delta: float, wish_vec: Vector3, grounded: bool, friction: float, speed_cap: float, accelerate: float, velocity: Vector3):
	velocity = friction(delta, grounded, ground_friction, velocity)
	var wish_speed = wish_vec.length() * speed_cap
	return accelerate(delta, wish_vec, wish_speed, accelerate, velocity)

var slide_limit = false

func move_ground(delta: float, wish_vec: Vector3, velocity: Vector3):
	var stance = nodes.get(PN.Controllers.STANCE)
	var capsule_rotation = nodes.get(PN.Controllers.CAPSULE_ROTATION)
	
	if(state.get_diving_state()):
		if(state.get_prop(PP.VELOCITY).length() < dive_stop_threshold  && !input.get_prop(PlayerInputs.CROUCH)):
			state.set_prop(PP.DIVING, false)
			input.set_prop(PlayerInputs.JUMP, false)
	
	if(state.get_sliding_state()):
		if(state.get_prop(PP.VELOCITY).length() < slide_stop_threshold && !input.get_prop(PlayerInputs.CROUCH)):
			state.set_prop(PP.SLIDING, false)
			input.set_prop(PlayerInputs.JUMP, false)

	if(input.get_prop(PlayerInputs.JUMP)):
		if(state.get_sliding_state()):
			if(state.get_prop(PP.VELOCITY).length() < slide_stop_threshold):
				state.set_prop(PP.SLIDING, false)
				input.set_prop(PlayerInputs.JUMP, false)
		elif(state.get_diving_state()):
			if(state.get_prop(PP.VELOCITY).length() < dive_stop_threshold):
				state.set_prop(PP.DIVING, false)
				input.set_prop(PlayerInputs.JUMP, false)
		else:
			if(input.get_prop(PlayerInputs.DIVE)):
				state.set_prop(PP.DIVING, true)
				input.set_prop(PlayerInputs.JUMP, false)
				capsule_rotation.set("rot_forward", wish_vec)
				input.set("yaw_basis", rad2deg(input.get_prop(PlayerInputs.CAMERA_ROTATION).y))
				
				if(!state.get_skating_state()):
					velocity.y = jump_velocity
					return move_air(delta, wish_vec, velocity)
			else:
				if(state.get_prop(PP.SLIDING)):
					state.set_prop(PP.SLIDING, false)
					if(velocity.length() > slide_skate_threshold):
						velocity = velocity.normalized() * slide_skate_threshold
			
				input.set_prop(PlayerInputs.JUMP, false)
				input.set_prop(PlayerInputs.SKATE, false)
				velocity.y = jump_velocity
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
