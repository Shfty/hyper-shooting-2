extends Node

export (NodePath) var player_node
var player_inst = null

onready var lateral_progress = $HBoxContainer/VBoxContainer/LateralVelocity
onready var vertical_progress = $HBoxContainer/VBoxContainer/VerticalVelocity
onready var accel_progress = $HBoxContainer/AccelerationProgress

var prev_lateral_vel = Vector3.ZERO

func _ready():
	assert(!player_node.is_empty())
	player_inst = get_node(player_node)
	
	var state: PlayerState = player_inst.get_player_state()
	prev_lateral_vel = state.get_velocity()

# warning-ignore:unused_argument
func _process(delta):
	var state: PlayerState = player_inst.get_player_state()
	
	var vel = state.get_velocity()
	var lateral_vel = Vector3(vel.x, 0, vel.z)
	var vertical_vel = Vector3(0, vel.y, 0)
	
	var acceleration = lateral_vel.length() - prev_lateral_vel.length()
	prev_lateral_vel = lateral_vel
	
	lateral_progress.set_value(lateral_vel.length())
	vertical_progress.set_value(vertical_vel.length())
	accel_progress.set_value(acceleration)
