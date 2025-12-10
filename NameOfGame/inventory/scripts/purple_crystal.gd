extends StaticBody2D

signal crystal_collected

@export var item: InvItem

var giraffe = null
var player = null

func _on_area_2d_body_entered(body):
	if body.has_method("Player"):
		player = body
		playercollect()
		await get_tree().create_timer(0.1).timeout
		queue_free()

func playercollect():
	player.collect(item)
	emit_signal("crystal_collected")
