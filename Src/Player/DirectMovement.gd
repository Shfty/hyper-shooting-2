extends Node

var delta_move = Vector3.ZERO

func _physics_process(delta):
	owner.global_transform.origin += delta_move
	delta_move = Vector3.ZERO

func add_delta_move(delta: Vector3, scale: float = 1.0):
	delta_move += delta

func add_delta_x(delta: float, scale: float = 1.0):
	delta_move.x += delta

func add_delta_y(delta: float, scale: float = 1.0):
	delta_move.y += delta

func add_delta_z(delta: float, scale: float = 1.0):
	delta_move.z += delta
