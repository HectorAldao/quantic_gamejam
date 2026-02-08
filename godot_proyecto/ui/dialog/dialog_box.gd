extends Control

signal change_move(tf: bool)

@onready var label = $Label
@onready var color_rect = $ColorRect

var current_npc: String = ""
var current_dialog_index: int = 0
var current_dialog_list: Array = []

func _ready() -> void:
	# Hide dialog box initially
	hide()


func start_dialog(npc_name: String, dialog_lines: Array = []) -> void:
	if dialog_lines.size() > 0:
		current_npc = npc_name
		current_dialog_list = dialog_lines
		current_dialog_index = 0
		show_current_dialog()
		show()
		change_move.emit(false)


func show_current_dialog() -> void:
	if current_dialog_index < current_dialog_list.size():
		label.text = current_dialog_list[current_dialog_index]


func advance_dialog() -> void:
	current_dialog_index += 1
	if current_dialog_index < current_dialog_list.size():
		show_current_dialog()
	else:
		# Dialog finished
		hide()
		current_npc = ""
		current_dialog_index = 0
		current_dialog_list = []
		change_move.emit(true)


func is_dialog_active() -> bool:
	return visible
