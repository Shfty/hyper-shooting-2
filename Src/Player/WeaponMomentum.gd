class_name WeaponMomentum
extends Spatial

export (bool) var enable_momentum = false setget set_enable_momentum
export (Vector3) var momentum_scale = Vector3(1.2, 1.2, 0.8)

var grounded = true setget set_grounded
var target = Vector3.ZERO

func set_enable_momentum(new_enable_momentum):
	if(enable_momentum != new_enable_momentum):
		enable_momentum = new_enable_momentum

func set_grounded(new_grounded):
	if(grounded != new_grounded):
		grounded = new_grounded

func moved(delta, delta_move):
	var velocity = delta_move / delta
	target = Vector3.ZERO
	
	if(!grounded || enable_momentum):
		velocity = velocity.rotated(Vector3.UP, -global_transform.basis.get_euler().y)
		velocity = velocity.rotated(Vector3.RIGHT, -global_transform.basis.get_euler().x)
		
		target = velocity * momentum_scale * -0.002

func _process(delta):
	translation = lerp(translation, target, 6 * delta)
