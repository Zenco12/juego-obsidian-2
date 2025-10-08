extends PlayerStateGravityBase

func on_physics_process(delta):	
	player.velocity.x = Input.get_axis("ui_left", "ui_right") * player.SPEED/2
		
	# si esta en el suelo y esta parado sobre él, podemos darle impulso de salto
	if player.is_on_floor() and player.velocity.y >= 0: 
		player.velocity.y = player.JUMP_VELOCITY
	# en otro caso, si está bajando, cambiamos al estado de cayendo
	elif controlled_node.velocity.y > 0: state_machine.change_to(player.states.Falling)
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
