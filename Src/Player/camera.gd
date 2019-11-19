extends Node

const STATE = "StateModel"
const CAMERA_YAW = "CameraYaw"
const CAMERA_PITCH = "CameraPitch"
var nodes = Util.NodeDependencies.new([
	STATE,
	CAMERA_YAW,
	CAMERA_PITCH
])

export(float) var sensitivity = 0.005
export(float) var pitch_min = -89.0
export(float) var pitch_max = 89.0
export(float) var recenter_speed = 10

var clamp_pitch: bool = true
var lerp_pitch = false

func _ready():
	nodes.ready(owner)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var state = nodes.get(STATE)
		var rotation = state.get_camera_rotation()
		
		# Yaw
		var yawSign = 1 if abs(rotation.x) >= PI * 0.5 else -1
		rotation.y += event.relative.x * sensitivity * yawSign
		
		# Pitch
		if(!lerp_pitch):
			rotation.x -= event.relative.y * sensitivity
			if(clamp_pitch):
				rotation.x = clamp(rotation.x, deg2rad(pitch_min), deg2rad(pitch_max))
		
		# Wrap rotation
		if(abs(rotation.x) > PI):
			rotation.x -= sign(rotation.x) * TAU
			
		if(abs(rotation.y) > PI):
			rotation.y -= sign(rotation.y) * TAU
		
		state.set_camera_rotation(rotation)

func _physics_process(delta):
	var state = nodes.get(STATE)
	var camera_yaw = nodes.get(CAMERA_YAW)
	var camera_pitch = nodes.get(CAMERA_PITCH)
	
	var rotation = state.get_camera_rotation()
	if(lerp_pitch):
		rotation.x = lerp(rotation.x, 0, delta * recenter_speed)
		if(abs(rotation.x) < deg2rad(1.0)):
			lerp_pitch = false
	state.set_camera_rotation(rotation)
	
	camera_yaw.rotation.y = rotation.y
	camera_pitch.rotation.x = rotation.x
	

func _on_StateModel_skating_changed(skate):
	print("Skate changed: ", skate)
	check_clamp()

func _on_StateModel_grounded_changed(grounded):
	print("Grounded changed: ", grounded)
	check_clamp()

func check_clamp():
	var state = nodes.get(STATE)
	var free_look = state.get_skating() || !state.get_grounded()
	clamp_pitch = !free_look
	
	var rotation = state.get_camera_rotation()
	if(clamp_pitch && rotation.x > deg2rad(pitch_max) || rotation.x < deg2rad(pitch_min)):
		print("Pitch out of bounds")
		lerp_pitch = true
