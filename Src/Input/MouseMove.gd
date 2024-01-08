class_name MouseMove
extends Node

export(Vector2) var sensitivity = Vector2(0.002, -0.002)

export(bool) var ignore_x = false setget set_ignore_x
export(bool) var ignore_y = false setget set_ignore_y

signal mouse_move_x(delta)
signal mouse_move_y(delta)

func set_ignore_x(new_ignore_x):
	if(ignore_x != new_ignore_x):
		ignore_x = new_ignore_x

func set_ignore_y(new_ignore_y):
	if(ignore_y != new_ignore_y):
		ignore_y = new_ignore_y

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var scaled = event.relative * sensitivity
		if(!ignore_x):
			emit_signal("mouse_move_x", scaled.x)
		
		if(!ignore_y):
			emit_signal("mouse_move_y", scaled.y)
