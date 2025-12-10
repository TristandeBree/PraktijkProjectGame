extends Area2D

signal start_quest_sums

@export var dialog_ui : Control
@export var sum_ui : Control
@export var crystals_needed = 5

@onready var player = %Player
@onready var pressELabel = %PressELabel
@onready var crystal_markers = %CrystalMarkers.get_children()

var player_inside : bool = false
var crystals_collected : int = 0
var crystals_spawned : bool = false
var quest_accepted : bool = false
var quest_finished : bool = false
var sums_finished : int = 0
var sums_to_finish : int = 2

var crystal_scene = preload("res://inventory/scenes/purple_crystal.tscn")
var dialog_start : String = "res://logic/scripts/JSON/safari_quest_one/quest_one_dialog_start.json"
var dialog_success : String = "res://logic/scripts/JSON/safari_quest_one/quest_one_dialog_success.json"
var dialog_incomplete : String = "res://logic/scripts/JSON/safari_quest_one/quest_one_dialog_incomplete.json"
var dialog_end : String = "res://logic/scripts/JSON/safari_quest_one/quest_one_dialog_end.json"

func _ready():
	pressELabel.visible = false
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	dialog_ui.connect("dialog_closed", Callable(self, "_on_dialog_closed"))
	sum_ui.connect("sum_success", Callable(self, "_on_sum_success"))

func _process(delta):
	if player_inside and Input.is_action_just_pressed("talk"):
		_open_dialog()

func _on_body_entered(body):
	if body == player:
		player_inside = true
		pressELabel.visible = true

func _on_body_exited(body):
	if body == player:
		player_inside = false
		pressELabel.visible = false

func _open_dialog():
	pressELabel.visible = false
	get_tree().paused = true
	
	var dialog_to_open = dialog_start
	if quest_accepted and not quest_finished:
		if crystals_collected == crystals_needed:
			dialog_to_open = dialog_success
			quest_finished = true
		else:
			dialog_to_open = dialog_incomplete
	elif quest_finished:
		dialog_to_open = dialog_end
	
	quest_accepted = true
	spawn_crystals()
	dialog_ui.open_dialog(dialog_to_open)

func _close_dialog():
	get_tree().paused = false
	if player_inside:
		pressELabel.visible = true

func _on_dialog_closed():
	_close_dialog()
	if quest_finished and sums_finished < sums_to_finish:
		emit_signal("start_quest_sums")

func _on_sum_success():
	sums_finished += 1

func _on_crystal_collected():
	crystals_collected += 1

func spawn_crystals():
	if crystals_spawned:
		return
	crystals_spawned = true
	for marker in crystal_markers:
		var item = crystal_scene.instantiate()
		add_child(item)
		item.global_position = marker.global_position
		item.player = player
		item.giraffe = %Giraffe
		if item.has_signal("crystal_collected"):
			item.connect("crystal_collected", Callable(self, "_on_crystal_collected"))
