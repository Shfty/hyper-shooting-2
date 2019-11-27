class_name UpdateMoveBobBehavior
extends NestedFSMBehavior

export(String) var player_state_key = "player_state"

export (float) var bob_frequency = 0.13
export (float) var lerp_rate = 8

func physics_process(delta):
	var player_state := get_context(player_state_key) as PlayerState
	
	var bob = player_state.get_bob()

	var velocity = player_state.get_velocity()
	velocity.y = 0
	var velocity_length = velocity.length()
	if(velocity_length > 1):
		bob += velocity_length * bob_frequency * delta
	else:
		if(bob <= 0.5):
			bob = lerp(bob, 0.0, delta * lerp_rate)
		else:
			bob = lerp(bob, 1.0, delta * lerp_rate)

	player_state.set_bob(fmod(bob, 1.0))
