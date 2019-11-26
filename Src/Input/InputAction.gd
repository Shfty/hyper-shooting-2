class_name InputAction
extends Node

export(String) var input_action
export(bool) var ignore_input setget set_ignore_input

var down = false setget set_down
var pressed = false
var released = false

signal down_changed(down)
signal pressed
signal released

func set_ignore_input(new_ignore_input):
	if(ignore_input != new_ignore_input):
		ignore_input = new_ignore_input
		if(!ignore_input):
			set_down(Input.is_action_pressed(input_action))

func set_down(new_down):
	if(down != new_down):
		down = new_down
		emit_signal("down_changed", down)
		if(down):
			emit_signal("pressed")
		else:
			emit_signal("released")

func _input(event):
	if(ignore_input):
		return
	
	if(event.is_action(input_action)):
		pressed = event.is_action_pressed(input_action)
		released = event.is_action_released(input_action)
		
		if(pressed):
			set_down(true)
		elif(released):
			set_down(false)
