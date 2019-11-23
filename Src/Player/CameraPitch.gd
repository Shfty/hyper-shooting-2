class_name CameraPitch
extends Spatial

export(float) var pitch_min = -89.0
export(float) var pitch_max = 89.0

export(bool) var lock_pitch = false
export(bool) var clamp_pitch = true

func get_pitch():
	return rotation.x

func set_pitch(new_pitch):
	rotation.x = new_pitch

func mouse_move_y(delta):
	if(!lock_pitch):
		rotation.x -= delta
		if(clamp_pitch):
			rotation.x = clamp(rotation.x, deg2rad(pitch_min), deg2rad(pitch_max))
