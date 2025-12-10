extends Control

signal dialog_closed

@export var dialog_script : String

@onready var close_button = $CloseButton
@onready var dialog_label = $DialogBox/RichTextLabel

var dialog_lines = []
var dialog_index = 0

func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("talk") or Input.is_action_just_pressed("read"):
		change_line()

func change_line():
	if dialog_index < len(dialog_lines):
		var line = dialog_lines[dialog_index]
		dialog_label.text = line["text"]
		dialog_index += 1
	else:
		dialog_index = 0
		close_dialog()

func open_dialog(script_path: String):
	if script_path != "":
		dialog_lines = load_script(script_path)
	else:
		dialog_lines = load_script(dialog_script)
		
	dialog_index = 0
	visible = true
	change_line()

func close_dialog():
	visible = false
	emit_signal("dialog_closed")

func load_script(file_path):
	if !FileAccess.file_exists(file_path):
		push_error("File path does not exist!")
		return -1
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if !file:
		push_error("Opening file failed!")
		return -1
	
	var content = file.get_as_text()
	return JSON.parse_string(content)

func _on_close_button_pressed() -> void:
	visible = false
	emit_signal("dialog_closed")
