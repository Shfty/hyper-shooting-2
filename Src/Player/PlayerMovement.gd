class_name MovementController
extends Node

onready var wish_vector_inst: WishVector = get_node("../../Input/WishVector")
onready var jump_action: InputAction = get_node("../../Input/JumpAction")
onready var crouch_action: InputAction = get_node("../../Input/CrouchAction")
onready var skate_action: InputAction = get_node("../../Input/SkateAction")

onready var player_fsm: PlayerState = get_node("../../PlayerFSM")
onready var player_state: PlayerState = get_node("../../PlayerState")
onready var stance = get_node("../PlayerStance")
onready var camera_yaw: CameraYaw = get_node("../../CameraRigGlobal/CameraRig/ViewBob/CameraYaw")
onready var directional_rotation: DirectionalRotation = get_node("../../DirectionalRotation")

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

var slide_limit = false

signal moved(delta, delta_move)

# @TODO: Prone rotation (rotate toward velocity, align to ground)
# @TODO: Fix prone collision (rotate to align to wall)
# @TODO: Go to full crouch, rotate, then uncrouch on prone recovery
# @TODO: Figure out solution to height difference between crouch / prone
# @TODO: Refactor sliding/diving state flags into prone flag
# @TODO: Apply overaim back prone while in air instead of on landing
# @TODO: Fix spline curve updates in editor, currently overpopulating data
# @TODO: Add reticle
# @TODO: Fire at reticle instead of weapon forward

# Functions
func _get_configuration_warning():
	if(!owner is KinematicBody):
		return "Owner must be a KinematicBody"
	
	return ""

func _physics_process(delta):
	# Fetch wish vector
	var wish_vector = wish_vector_inst.get_wish_vector(camera_yaw.get_yaw())
	
	# Project onto wall if colliding
	var slide_count = owner.get_slide_count()
	if(owner.is_on_wall() && slide_count > 0):
		var collision = owner.get_slide_collision(0)
		var wall_normal = collision.normal
		var wall_perp = wall_normal.cross(Vector3.UP).normalized()
		var wish_sign = wish_vector.dot(wall_perp)
		
		var prev_wish_vector = wish_vector
		wish_vector = wall_perp.normalized() * wish_sign
	
	var velocity = player_state.get_velocity()
	if owner.is_on_floor():
		velocity = move_ground(delta, wish_vector, velocity)
	else:
		velocity = move_air(delta, wish_vector, velocity)
	
	velocity = add_gravity(delta, velocity)
	velocity = apply_velocity(delta, velocity)
	
	player_state.set_velocity(velocity)
	
func apply_velocity(delta, velocity):
	var skate = player_fsm.get_skating_state()
	var ground_vector = Vector3.DOWN * ground_trace_distance if player_state.get_grounded() && !skate else Vector3.DOWN
	var prev_translation = owner.global_transform.origin
	velocity = owner.move_and_slide_with_snap(velocity, ground_vector, Vector3.UP, !skate, 4, deg2rad(max_slope_angle))
	emit_signal("moved", delta, owner.global_transform.origin - prev_translation)
	return velocity

func add_gravity(delta: float, velocity: Vector3):
	if(!owner.is_on_floor()):
		return velocity - Vector3(0, gravity * delta, 0)
	return velocity

func move(delta: float, wish_vec: Vector3, grounded: bool, friction: float, speed_cap: float, accelerate: float, velocity: Vector3):
	velocity = friction(delta, grounded, ground_friction, velocity)
	var wish_speed = wish_vec.length() * speed_cap
	return accelerate(delta, wish_vec, wish_speed, accelerate, velocity)

func move_ground(delta: float, wish_vec: Vector3, velocity: Vector3):
	if(player_fsm.get_diving_state() && !player_fsm.get_skating_state()):
		if(player_state.get_velocity().length() < dive_stop_threshold  && !crouch_action.down):
			player_state.set_diving(false)
			jump_action.set_down(false)
	
	if(player_fsm.get_sliding_state() && !player_fsm.get_skating_state()):
		if(player_state.get_velocity().length() < slide_stop_threshold && !crouch_action.down):
			player_state.set_sliding(false)
			jump_action.set_down(false)

	if(jump_action.down):
		if(player_fsm.get_sliding_state()):
			if(player_state.get_velocity().length() < slide_stop_threshold || player_fsm.get_skating_state()):
				player_state.set_sliding(false)
				jump_action.set_down(false)
		elif(player_fsm.get_diving_state()):
			if(player_state.get_grounded()):
				player_state.set_diving(false)
				jump_action.set_down(false)
		else:
			if(dive_command()):
				player_state.set_diving(true)
				jump_action.set_down(false)
				directional_rotation.set_rot_forward(wish_vec)
				camera_yaw.reset_yaw_basis()
				
				if(!player_fsm.get_skating_state()):
					velocity = wish_vec.normalized() * dive_impulse
					velocity.y = jump_impulse
					return move_air(delta, wish_vec, velocity)
			else:
				if(player_state.get_sliding()):
					player_state.set_sliding(false)
					if(velocity.length() > slide_skate_threshold):
						velocity = velocity.normalized() * slide_skate_threshold
			
				jump_action.set_down(false)
				velocity.y = jump_impulse
				return move_air(delta, wish_vec, velocity)
	
	if(slide_command() && player_fsm.get_action_state() == PlayerFSM.ACTION_STATE.CROUCHING && !stance.is_fully_crouched()):
		player_state.set_sliding(true)
		directional_rotation.set_rot_forward(wish_vec)
		camera_yaw.reset_yaw_basis()
		if(!player_fsm.get_skating_state()):
			slide_limit = true
			velocity = wish_vec * slide_impulse
	
	player_state.set_grounded(true)
	
	if(player_fsm.get_sliding_state() && slide_limit && velocity.length() < slide_skate_threshold):
		slide_limit = false
	
	if(player_fsm.get_skating_state()):
		var is_sliding_limited = player_fsm.get_sliding_state() && slide_limit == true
		if(!is_sliding_limited):
			return move_air(delta, wish_vec, velocity)
	
	var is_prone = player_fsm.get_action_state() == PlayerFSM.ACTION_STATE.BACK_PRONE || player_fsm.get_action_state() == PlayerFSM.ACTION_STATE.FRONT_PRONE
	var friction = prone_friction if is_prone else ground_friction
	var speed_cap = crouch_speed if player_fsm.get_action_state() == PlayerFSM.ACTION_STATE.CROUCHING else move_speed
	var accelerate = prone_accelerate if is_prone else ground_accelerate
	
	return move(delta, wish_vec, true, friction, speed_cap, accelerate, velocity)

func slide_command():
	return crouch_action.down && Input.is_action_just_pressed("move_forward")

func dive_command():
	return wish_vector_inst.get_wish_vector().length() > 0.5 && crouch_action.down && jump_action.pressed

func move_air(delta: float, wish_vec: Vector3, velocity: Vector3):
	if(!skate_action.down):
		player_state.set_grounded(false)
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
