class_name WeaponMomentumBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"
export(String) var weapon_momentum_spatial_key = "weapon_momentum_spatial"

export (Vector3) var momentum_scale = Vector3(1.2, 1.2, 0.8)
export (float) var transition_speed = 6.0

var target = Vector3.ZERO

# warning-ignore:unused_argument
func physics_process(delta):
	var player_state = get_context(player_state_key) as PlayerState
	var weapon_momentum_spatial := get_context(weapon_momentum_spatial_key) as Spatial
	
	var velocity = player_state.get_velocity()
	velocity = velocity.rotated(Vector3.UP, -weapon_momentum_spatial.global_transform.basis.get_euler().y)
	velocity = velocity.rotated(Vector3.RIGHT, -weapon_momentum_spatial.global_transform.basis.get_euler().x)
	
	target = velocity * momentum_scale * -0.002

func process(delta):
	var weapon_momentum_spatial := get_context(weapon_momentum_spatial_key) as Spatial
	weapon_momentum_spatial.translation = lerp(weapon_momentum_spatial.translation, target, delta * transition_speed)
