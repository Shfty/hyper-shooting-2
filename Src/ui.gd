extends Node

export (NodePath) var player_node
var player_inst = null

const LATERAL_PROGRESS = "LateralVelocity"
const VERTICAL_PROGRESS = "VerticalVelocity"
var nodes = Util.NodeDependencies.new([
	LATERAL_PROGRESS,
	VERTICAL_PROGRESS
])

func _ready():
	assert(!player_node.is_empty())
	player_inst = get_node(player_node)
	
	nodes.ready(owner)

func _process(delta):
	var lateral_progress = nodes.get(LATERAL_PROGRESS)
	var vertical_progress = nodes.get(VERTICAL_PROGRESS)
	
	var state = player_inst.find_node("StateModel")
	var vel = state.get("velocity")
	var lateralVel = Vector3(vel.x, 0, vel.z)
	var verticalVel = Vector3(0, vel.y, 0)
	lateral_progress.set_value(lateralVel.length())
	vertical_progress.set_value(verticalVel.length())