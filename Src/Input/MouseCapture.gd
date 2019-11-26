class_name MouseCapture
extends Node

enum MouseMode {
	VISIBLE,
	HIDDEN,
	CAPTURED,
	CONFINED
}

export(MouseMode) var capture_mouse = MouseMode.VISIBLE setget set_capture_mouse

func set_capture_mouse(new_capture_mouse):
	if(capture_mouse != new_capture_mouse):
		capture_mouse = new_capture_mouse
		
		match(capture_mouse):
			MouseMode.VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			MouseMode.HIDDEN:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			MouseMode.CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			MouseMode.CONFINED:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
