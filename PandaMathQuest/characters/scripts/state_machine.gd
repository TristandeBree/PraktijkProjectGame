extends Node

var states = {}
var current_state = null
var player = null

func init(player_ref):
	player = player_ref
	for child in get_children():
		states[child.name] = child
		child.player = player
		child.state_machine = self
	change_state("Idle")

func change_state(new_state_name: String):
	if current_state:
		current_state.exit()
	current_state = states.get(new_state_name)
	current_state.enter()

func update(delta):
	if current_state:
		current_state.update(delta)
