extends Node
var player
var state_machine

func enter():
	player.sprite.play("walk_right")
	player.particles.emitting = true

func update(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction == 0:
		state_machine.change_state("Idle")
	elif Input.is_action_pressed("jump") and player.is_on_floor():
		state_machine.change_state("Jump")
	elif not player.is_on_floor():
		state_machine.change_state("Fall")

	player.velocity.x = move_toward(player.velocity.x, direction * player.SPEED, player.SPEED)
	player.move_and_slide()

	if direction > 0:
		player.sprite.animation = "walk_right"
	elif direction < 0:
		player.sprite.animation = "walk_left"

func exit():
	player.particles.emitting = false
