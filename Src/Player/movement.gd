extends Node

const PLAYER = "KinematicBody"
const CAMERA_YAW = "CameraYaw"
var nodes = Util.NodeDependencies.new([
	PLAYER,
	CAMERA_YAW
])

export(float) var move_speed = 320.0
export(float) var stop_speed = 100.0

export(float) var gravity = 800.0

export(float) var ground_friction = 6.0
export(float) var max_slope_angle = 65.0

export(float) var ground_accelerate = 10.0
export(float) var air_accelerate = 3.0

export(float) var jump_velocity = 270

export (Vector3) var velocity = Vector3.ZERO

# Jump buffer
var wants_jump: bool = false

# Grounded
var grounded: bool = true setget set_grounded, get_grounded

func get_grounded():
	return grounded

func set_grounded(ground):
	if(grounded != ground):
		grounded = ground
		emit_signal("grounded_changed", grounded)

signal grounded_changed(grounded)

# Skating
var skating: bool = false setget set_skate, get_skate

func get_skate():
	return skating

func set_skate(skate):
	if(skating != skate):
		skating = skate
		emit_signal("skating_changed", skating)

signal skating_changed(skating)

# Functions
func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var wish_vector = get_wish_vector("move_left", "move_right", "move_forward", "move_back")
	check_jump()
	check_skate()
	
	var move_walk = FP.curry(self, "move_walk", [delta, wish_vector])
	var move_air = FP.curry(self, "move_air", [delta, wish_vector])
	
	velocity = FP.pipe(velocity, [
		move_walk if nodes.get(PLAYER).is_on_floor() else move_air,
		FP.curry(self, "add_gravity", [delta]),
		FP.curry(self, "apply_velocity", [])
	])

func check_jump():
	if(!is_action_pressed("jump")):
		wants_jump = false
		return
	
	if(Input.is_action_just_pressed("jump")):
		wants_jump = true

func check_skate():
	if(!is_action_pressed("skate")):
		set_skate(false)
		return
	
	if(Input.is_action_just_pressed("skate")):
		set_skate(true)

func apply_velocity(velocity):
	return nodes.get(PLAYER).move_and_slide_with_snap(velocity, Vector3.DOWN, Vector3.UP, !get_skate(), 4, deg2rad(max_slope_angle))

func add_gravity(delta: float, velocity: Vector3):
	return velocity - Vector3(0, gravity * delta, 0)

func is_action_pressed(action: String):
	return Input.is_action_pressed(action)

func get_wish_axis(neg_action: String, pos_action: String):
	return Util.bool_to_int(is_action_pressed(neg_action), -1) + Util.bool_to_int(is_action_pressed(pos_action), 1)

func get_wish_vector(left_action: String, right_action: String, forward_action: String, back_action: String):
	return Vector3(
		get_wish_axis(left_action, right_action),
		0,
		get_wish_axis(forward_action, back_action)
	).rotated(
		Vector3(0, 1, 0), nodes.get(CAMERA_YAW).rotation.y
	).normalized()

func move(delta: float, wish_vec: Vector3, grounded: bool, accelerate: float, velocity: Vector3):
	velocity = friction(delta, grounded, velocity)
	var wish_speed = wish_vec.length() * move_speed
	return accelerate(delta, wish_vec, wish_speed, accelerate, velocity)

func move_walk(delta: float, wish_vec: Vector3, velocity: Vector3):
	if(wants_jump):
		wants_jump = false
		set_skate(false)
		velocity.y = jump_velocity
		return move_air(delta, wish_vec, velocity)
	
	set_grounded(true)
	
	if(get_skate()):
		return move_air(delta, wish_vec, velocity)
	
	return move(delta, wish_vec, true, ground_accelerate, velocity)

func move_air(delta: float, wish_vec: Vector3, velocity: Vector3):
	if(!skating):
		set_grounded(false)
	return move(delta, wish_vec, false, air_accelerate, velocity)

func friction(delta: float, walking: bool, velocity: Vector3):
	var speed = velocity.length()
	if(speed < 1):
		velocity.x = 0
		velocity.z = 0
	
	var drop = 0
	if(walking):
		var control = stop_speed if speed < stop_speed else speed
		drop = control * ground_friction * delta
	
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
