extends Node

export (NodePath) var player_node
var player_inst = null

onready var lateral_progress = $HBoxContainer/VBoxContainer/LateralVelocity
onready var vertical_progress = $HBoxContainer/VBoxContainer/VerticalVelocity

func _ready():
	assert(!player_node.is_empty())
	player_inst = get_node(player_node)

func _process(delta):
	var state = player_inst.find_node("PlayerState")
	var vel = state.get_velocity()
	var lateralVel = Vector3(vel.x, 0, vel.z)
	var verticalVel = Vector3(0, vel.y, 0)
	lateral_progress.set_value(lateralVel.length())
	vertical_progress.set_value(verticalVel.length())
