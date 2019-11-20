extends Node

export (NodePath) var player_node
var player_inst = null

var nodes = Util.NodeDependencies.new([
	UIN.LATERAL_PROGRESS,
	UIN.VERTICAL_PROGRESS
])

func _ready():
	assert(!player_node.is_empty())
	player_inst = get_node(player_node)
	
	nodes.ready(owner)

func _process(delta):
	var lateral_progress = nodes.get(UIN.LATERAL_PROGRESS)
	var vertical_progress = nodes.get(UIN.VERTICAL_PROGRESS)
	
	var state = player_inst.find_node(PN.Models.STATE)
	var vel = state.get_prop(PP.VELOCITY)
	var lateralVel = Vector3(vel.x, 0, vel.z)
	var verticalVel = Vector3(0, vel.y, 0)
	lateral_progress.set_value(lateralVel.length())
	vertical_progress.set_value(verticalVel.length())
