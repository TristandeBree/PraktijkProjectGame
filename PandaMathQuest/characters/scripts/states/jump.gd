extends Node
var player
var state_machine

func enter():
	player.velocity.y = player.JUMP_VELOCITY
	player.get_node("JumpAudio").play()
	player.sprite.play("jump")
	player.particles.emitting = false

func update(delta):
	if player.velocity.y > 0:
		state_machine.change_state("Fall")
	player.velocity += player.get_gravity() * delta
	player.move_and_slide()

func exit():
	pass
