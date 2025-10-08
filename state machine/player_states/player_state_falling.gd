extends PlayerStateGravityBase


func on_physics_process(delta):	
	player.velocity.x = Input.get_axis("ui_left", "ui_right") * player.SPEED/2
	
	if player.is_on_floor() and Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"): 
		state_machine.change_to(player.states.Running)
	elif player.velocity.y >= 0 and player.is_on_floor():
		state_machine.change_to(player.states.Idle)
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
	
