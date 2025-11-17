extends Node
var player
var state_machine

func enter():
	player.sprite.play("idle")
	player.particles.emitting = false

func update(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_machine.change_state("Walk")
	elif Input.is_action_pressed("jump") and player.is_on_floor():
		state_machine.change_state("Jump")
	elif not player.is_on_floor():
		state_machine.change_state("Fall")

func exit():
	pass
