extends Area

signal button_pressed

func _ready():
	connect("body_entered", self, "handle_body_entered")

func handle_body_entered(body):
	emit_signal("button_pressed")