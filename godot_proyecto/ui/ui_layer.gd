extends CanvasLayer

@onready var dialog_box = $HUDContainer/DialogBox

func _ready() -> void:
	await get_tree().process_frame
	
	# Connect all cientifica NPCs
	var root = get_tree().current_scene
	_connect_npcs(root)


func _connect_npcs(node: Node) -> void:
	#print(node)
	if node.has_signal("dialog_requested"):
		print(node,"has dialog_requested")
		node.dialog_requested.connect(_on_dialog_requested)
	
	for child in node.get_children():
		_connect_npcs(child)


func _on_dialog_requested(npc_name: String, dialog_lines: Array = []) -> void:
	print("_on_dialog_requested")
	if not dialog_box.is_dialog_active():
		dialog_box.start_dialog(npc_name, dialog_lines)
	else:
		dialog_box.advance_dialog()
