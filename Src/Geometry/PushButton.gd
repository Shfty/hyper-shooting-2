extends Area

signal button_pressed

func _ready():
# warning-ignore:return_value_discarded
	connect("body_entered", self, "handle_body_entered")

# warning-ignore:unused_argument
func handle_body_entered(body):
	emit_signal("button_pressed")