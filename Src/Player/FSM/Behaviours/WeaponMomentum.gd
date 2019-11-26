class_name WeaponMomentumBehavior
extends NestedFSMBehavior

export(NodePath) var weapon_momentum_spatial
onready var weapon_momentum_spatial_inst = get_node(weapon_momentum_spatial) if !weapon_momentum_spatial.is_empty() else null

export (Vector3) var momentum_scale = Vector3(1.2, 1.2, 0.8)
export (float) var transition_speed = 6.0

var target = Vector3.ZERO

# warning-ignore:unused_argument
func physics_process(delta):
	if(weapon_momentum_spatial_inst == null):
		return
	
	var player_state = get_context_inst() as PlayerState
	
	var velocity = player_state.get_velocity()
	velocity = velocity.rotated(Vector3.UP, -weapon_momentum_spatial_inst.global_transform.basis.get_euler().y)
	velocity = velocity.rotated(Vector3.RIGHT, -weapon_momentum_spatial_inst.global_transform.basis.get_euler().x)
	
	target = velocity * momentum_scale * -0.002

func process(delta):
	if(weapon_momentum_spatial_inst == null):
		return
	
	weapon_momentum_spatial_inst.translation = lerp(weapon_momentum_spatial_inst.translation, target, delta * transition_speed)
