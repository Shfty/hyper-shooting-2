extends Node

const PLAYER = "KinematicBody"
var nodes = Util.NodeDependencies.new([
	PLAYER
])

export (float) var height = 56

func _ready():
	nodes.ready(owner)

func _physics_process(delta):
	var player = nodes.get(PLAYER)
