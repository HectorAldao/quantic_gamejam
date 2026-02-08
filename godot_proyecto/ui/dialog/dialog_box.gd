extends Control

@onready var label = $Label
@onready var color_rect = $ColorRect

var dialogs: Dictionary = {}
var current_npc: String = ""
var current_dialog_index: int = 0
var current_dialog_list: Array = []

func _ready() -> void:
	# Load dialogs from JSON
	var file = FileAccess.open("res://ui/dialog/dialogs/dialogs.json", FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		if parse_result == OK:
			dialogs = json.get_data()
	
	# Hide dialog box initially
	hide()


func start_dialog(npc_name: String) -> void:
	if npc_name in dialogs:
		current_npc = npc_name
		current_dialog_list = dialogs[npc_name]
		current_dialog_index = 0
		show_current_dialog()
		show()


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


func is_dialog_active() -> bool:
	return visible

