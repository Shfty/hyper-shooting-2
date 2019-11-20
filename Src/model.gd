class_name Model
extends Node

export (Dictionary) var properties = {}
signal property_changed(prop_name, prop_value)

func get_prop(prop_name: String):
	return self.properties[prop_name]

func set_prop(prop_name: String, prop_value):
	if(self.properties[prop_name] != prop_value):
		self.properties[prop_name] = prop_value
		emit_signal("property_changed", prop_name, prop_value)
