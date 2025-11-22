extends Node
var player
var state_machine

func enter():
	player.sprite.play("jump")

func update(delta):
	player.velocity += player.get_gravity() * delta
	player.move_and_slide()
	if player.is_on_floor():
		state_machine.change_state("Idle")

func exit():
	pass
