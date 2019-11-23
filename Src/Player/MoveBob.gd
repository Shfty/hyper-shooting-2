class_name MoveBob
extends Node

export(bool) var bob_disabled = false setget set_bob_disabled
export (float) var bob_frequency = 0.03
export (float) var lerp_rate = 8

var bob = 0.0 setget set_bob
var grounded = true setget set_grounded

signal bob_changed(bob)

func set_bob_disabled(new_bob_disabled):
	if(bob_disabled != new_bob_disabled):
		bob_disabled = new_bob_disabled

func set_bob(new_bob):
	if(bob != new_bob):
		bob = new_bob
		emit_signal("bob_changed", bob)

func set_grounded(new_grounded):
	if(grounded != new_grounded):
		grounded = new_grounded

func moved(delta, delta_move):
	var new_bob = bob
	if(grounded && !bob_disabled && delta_move.length() > 1):
		new_bob += delta_move.length() * bob_frequency
	else:
		if(new_bob <= PI):
			new_bob = lerp(new_bob, 0, delta * lerp_rate)
		else:
			new_bob = lerp(new_bob, TAU, delta * lerp_rate)
		
	if(new_bob >= TAU):
		new_bob = 0
	set_bob(new_bob)

