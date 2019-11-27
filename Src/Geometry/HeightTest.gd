tool

extends Node

export(float) var unit_size = 2 setget set_unit_size

func set_unit_size(new_unit_size):
	if(unit_size != new_unit_size):
		unit_size = new_unit_size
		update_boxes()

func _ready():
	update_boxes()

func update_boxes():
	for child in get_children():
		child.queue_free()
	
	for i in range(1, 10):
		var idx = float(i)
		create_box(Vector3((idx - (unit_size * 0.1)) * unit_size, idx * (unit_size * 0.1), 0), idx * (unit_size * 0.2))

func create_box(translation, height):
	var box = CSGBox.new()
	box.width = unit_size
	box.height = height
	box.depth = unit_size
	box.translation = translation
	box.use_collision = true
	add_child(box)