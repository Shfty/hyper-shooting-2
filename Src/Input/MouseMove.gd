class_name MouseMove
extends Node

export(Vector2) var sensitivity = Vector2(0.002, -0.002)

signal mouse_move_x(delta)
signal mouse_move_y(delta)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var scaled = event.relative * sensitivity
		emit_signal("mouse_move_x", scaled.x)
		emit_signal("mouse_move_y", scaled.y)
