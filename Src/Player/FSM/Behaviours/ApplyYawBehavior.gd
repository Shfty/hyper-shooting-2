class_name ApplyYawBehavior
extends NestedFSMBehavior

export(NodePath) var yaw_spatial
onready var yaw_spatial_inst = Util.get_node_from_path(self, yaw_spatial)

func physics_process(delta):
	if(yaw_spatial_inst == null):
		return
	
	var player_state := get_context("player_state") as PlayerState
	var yaw = player_state.get_yaw()
	yaw_spatial_inst.rotation.y = yaw
