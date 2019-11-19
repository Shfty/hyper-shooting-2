extends Node

const CAMERA_YAW = "CameraYaw"
const CAMERA_PITCH = "CameraPitch"
var nodes = Util.NodeDependencies.new([
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
		var camera_yaw = nodes.get(CAMERA_YAW)
		var camera_pitch = nodes.get(CAMERA_PITCH)
		
		# Yaw
		var yawSign = 1 if abs(camera_pitch.rotation.x) >= PI * 0.5 else -1
		camera_yaw.rotate(Vector3(0, yawSign, 0), event.relative.x * sensitivity)
		
		# Pitch
		if(!lerp_pitch):
			camera_pitch.rotate(Vector3(-1, 0, 0), event.relative.y * sensitivity)
			if(clamp_pitch):
				camera_pitch.rotation.x = clamp(camera_pitch.rotation.x, deg2rad(pitch_min), deg2rad(pitch_max))

func _physics_process(delta):
	if(lerp_pitch):
		var camera_pitch = nodes.get(CAMERA_PITCH)
		camera_pitch.rotation.x = lerp(camera_pitch.rotation.x, 0, delta * recenter_speed)
		if(abs(camera_pitch.rotation.x) < deg2rad(1.0)):
			lerp_pitch = false

func _on_MovementController_skating_changed(skate):
	print("Skate changed: ", skate)
	check_clamp()

func _on_MovementController_grounded_changed(grounded):
	print("Grounded changed: ", grounded)
	check_clamp()

func check_clamp():
	var movement = owner.find_node("MovementController")
	var free_look = movement.get("skating") || !movement.get("grounded")
	clamp_pitch = !free_look
	
	var camera_pitch = nodes.get(CAMERA_PITCH)
	if(clamp_pitch && camera_pitch.rotation.x > deg2rad(pitch_max) || camera_pitch.rotation.x < deg2rad(pitch_min)):
		print("Pitch out of bounds")
		lerp_pitch = true
