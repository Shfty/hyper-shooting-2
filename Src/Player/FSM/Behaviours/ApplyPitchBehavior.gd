class_name ApplyPitchBehavior
extends NestedFSMBehavior

export(NodePath) var pitch_spatial
onready var pitch_spatial_inst = Util.get_node_from_path(self, pitch_spatial)

func physics_process(delta):
	if(pitch_spatial_inst == null):
		return
	
	var player_state := get_context_inst() as PlayerState
	var pitch = player_state.get_pitch()
	pitch_spatial_inst.rotation.x = pitch
