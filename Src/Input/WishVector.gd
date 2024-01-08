class_name WishVector
extends Node

export(String) var left_action
export(String) var right_action
export(String) var forward_action
export(String) var back_action

var wish_vector: Vector3 = Vector3.ZERO

func _input(event: InputEvent):
	if(event.is_action(left_action)
	|| event.is_action(right_action)
	|| event.is_action(forward_action)
	|| event.is_action(back_action)
	):
		wish_vector.x = get_wish_axis(event, left_action, right_action)
		wish_vector.z = get_wish_axis(event, forward_action, back_action)

func get_wish_axis(event: InputEvent, neg_action: String, pos_action: String):
	return bool_to_int(Input.is_action_pressed(neg_action), -1) + bool_to_int(Input.is_action_pressed(pos_action), 1)

static func bool_to_int(boolean, number):
	return number if boolean else 0

func get_wish_vector(yaw: float = 0.0):
	return wish_vector.rotated(Vector3.UP, yaw).normalized()
