tool

extends Node

func _init():
	for child in get_children():
		child.queue_free()
	
	for i in range(1, 10):
		create_box(Vector3((i - 5) * 50, i * 5, 0), i * 10)
		

func create_box(translation, height):
	var box = CSGBox.new()
	box.width = 50
	box.height = height
	box.depth = 50
	box.translation = translation
	box.use_collision = true
	add_child(box)