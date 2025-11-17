extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var kill_height = 500

@export var inv: Inv
@onready var state_machine = $StateMachine
@onready var sprite = $AnimatedSprite2D
@onready var particles = $leaf/CPUParticles2D

func _ready():
	state_machine.init(self)

func _physics_process(delta):
	state_machine.update(delta)

func collect(item):
	inv.insert(item)

func _process(delta):
	if global_position.y > kill_height:
		respawn_player()

func respawn_player():
	get_tree().reload_current_scene()
	
func Player():
	pass
