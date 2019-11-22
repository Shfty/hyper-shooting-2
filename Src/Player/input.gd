extends Model

var nodes = Util.NodeDependencies.new([
	PN.Spatial.UNCROUCH_RAYCAST
])

export(float) var sensitivity = 0.005
export(float) var pitch_min = -89.0
export(float) var pitch_max = 89.0

var lock_pitch = false
var clamp_pitch = true

var clamp_yaw = false
var yaw_basis = 0.0
var yaw_limit = 90.0

func _init():
	self.properties = {
	# Axis inputs
	PlayerInputs.WISH_VECTOR: Vector3.ZERO,
	PlayerInputs.CAMERA_ROTATION: Vector3.ZERO,
	
	# Direct button inputs
	PlayerInputs.JUMP: false,
	PlayerInputs.CROUCH: false,
	PlayerInputs.SKATE: false,
	
	# Derived commands
	PlayerInputs.SLIDE: false,
	PlayerInputs.DIVE: false
}

func _ready():
	nodes.ready(owner)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var rotation = get_prop(PlayerInputs.CAMERA_ROTATION)
		
		# Yaw
		var yawSign = 1 if abs(rotation.x) >= PI * 0.5 else -1
		rotation.y += event.relative.x * sensitivity * yawSign
		
		if(clamp_yaw):
			rotation.y = clamp(rotation.y, deg2rad(yaw_basis - yaw_limit), deg2rad(yaw_basis + yaw_limit))
		
		# Pitch
		if(!lock_pitch):
			rotation.x -= event.relative.y * sensitivity
			if(clamp_pitch):
				rotation.x = clamp(rotation.x, deg2rad(pitch_min), deg2rad(pitch_max))
		
		set_prop(PlayerInputs.CAMERA_ROTATION, rotation)

	# Wish Vector
	set_prop(PlayerInputs.WISH_VECTOR, get_wish_vector("move_left", "move_right", "move_forward", "move_back"))
	
	# Direct inputs
	press_gate(PlayerInputs.SKATE, PlayerInputs.SKATE)
	check_jump()
	check_crouch()
	
	# Commands
	set_prop(PlayerInputs.SLIDE, get_prop(PlayerInputs.CROUCH) && event.is_action_pressed("move_forward"))
	set_prop(PlayerInputs.DIVE, get_prop(PlayerInputs.WISH_VECTOR).length() > 0.5 && get_prop(PlayerInputs.CROUCH) && event.is_action_pressed(PlayerInputs.JUMP))

func get_wish_vector(left_action: String, right_action: String, forward_action: String, back_action: String):
	return Vector3(
		get_wish_axis(left_action, right_action),
		0,
		get_wish_axis(forward_action, back_action)
	).normalized()

func get_wish_axis(neg_action: String, pos_action: String):
	return Util.bool_to_int(Input.is_action_pressed(neg_action), -1) + Util.bool_to_int(Input.is_action_pressed(pos_action), 1)

func press_gate(input_action, input_prop):
	if(!Input.is_action_pressed(input_action)):
		set_prop(input_prop, false)
		return
	
	if(Input.is_action_just_pressed(input_action)):
		set_prop(input_prop, true)
	
func check_jump():
	var uncrouch_raycast = nodes.get(PN.Spatial.UNCROUCH_RAYCAST)
	if(!Input.is_action_pressed(PlayerInputs.JUMP)):
		set_prop(PlayerInputs.JUMP, false)
	
	if(Input.is_action_just_pressed(PlayerInputs.JUMP) && !uncrouch_raycast.is_colliding()):
		set_prop(PlayerInputs.JUMP, true)
	
func check_crouch():
	var uncrouch_raycast = nodes.get(PN.Spatial.UNCROUCH_RAYCAST)
	if(!Input.is_action_pressed(PlayerInputs.CROUCH) && !uncrouch_raycast.is_colliding()):
		set_prop(PlayerInputs.CROUCH, false)
	
	if(Input.is_action_just_pressed(PlayerInputs.CROUCH)):
		set_prop(PlayerInputs.CROUCH, true)
