tool
class_name PlayerPitch
extends Node

export(float) var recenter_speed = 10.0

var lerp_pitch = false
var target_rotation = 0.0
var lerp_finish_threshold = 1.0
var free_look = false
var in_bounds = true

onready var camera_pitch: CameraPitch = get_parent()

var player_state: PlayerState = null setget set_player_state

func should_run():
	return !Engine.is_editor_hint() && player_state != null && get_parent() is CameraPitch

func _get_configuration_warning():
	if(!get_parent() is CameraPitch):
		return "Parent must be a CameraPitch node"
	return ""

func set_player_state(new_player_state):
	if(player_state != new_player_state):
		player_state = new_player_state
		
# warning-ignore:return_value_discarded
		player_state.connect("grounded_changed", self, "update_free_look")
# warning-ignore:return_value_discarded
		player_state.connect("prone_changed", self, "update_free_look")
# warning-ignore:return_value_discarded
		player_state.connect("skating_changed", self, "update_free_look")
		
# warning-ignore:return_value_discarded
		player_state.connect("grounded_changed", self, "update_in_bounds")
# warning-ignore:return_value_discarded
		player_state.connect("prone_changed", self, "update_in_bounds")

func pitch_changed(new_pitch):
	camera_pitch.rotation.x = fmod(new_pitch, TAU)
	update_in_bounds(null)

# warning-ignore:unused_argument
func update_free_look(ignore):
	if(!should_run()):
		return
	
	update_lerp_pitch(null)

# warning-ignore:unused_argument
func update_in_bounds(ignore):
	var pitch = player_state.get_pitch()
	var pitch_min = deg2rad(camera_pitch.pitch_min - 1)
	var pitch_max = deg2rad(camera_pitch.pitch_max + 1)
	
	in_bounds = pitch > pitch_min && pitch < pitch_max
	update_lerp_pitch(null)

func set_lerp_pitch(new_lerp_pitch):
	if(lerp_pitch != new_lerp_pitch):
		lerp_pitch = new_lerp_pitch
		camera_pitch.lock_pitch = lerp_pitch

# warning-ignore:unused_argument
func update_lerp_pitch(ignore):
	if(!should_run()):
		return
		
	var pitch = player_state.get_pitch()
	
	# If out of bounds and not in free look, start pitch interpolation
	if(!free_look && !in_bounds && !lerp_pitch):
		set_lerp_pitch(true)
		target_rotation = 0.0
		
		if(!player_state.get_prone()):
			if(pitch > 0.0):
				# Wrap rotation back to negative
				target_rotation = pitch + (TAU - fposmod(pitch, TAU))
			elif(pitch < 0.0):
				# Wrap rotation back to positive
				target_rotation = pitch - (TAU - (TAU - fposmod(pitch, TAU)))

func _ready():
# warning-ignore:return_value_discarded
	camera_pitch.connect("pitch_changed", self, "pitch_changed")

func _process(delta):
	if(!should_run()):
		return
	
	if(lerp_pitch):
		var pitch = camera_pitch.get_pitch()
		pitch = lerp(pitch, target_rotation, delta * recenter_speed)
		
		if(abs(target_rotation - pitch) < deg2rad(lerp_finish_threshold)):
			if(abs(pitch) > PI):
				pitch = (TAU - abs(pitch)) * -sign(pitch)
			set_lerp_pitch(false)
	
		camera_pitch.set_pitch(pitch)
