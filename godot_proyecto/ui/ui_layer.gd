extends CanvasLayer

@onready var dialog_box = $HUDContainer/DialogBox

@onready var colorrect: ColorRect = $HUDContainer/ColorRect
@onready var animation_fade_in: AnimationPlayer = $HUDContainer/ColorRect/AnimationPlayer
@onready var label_cientifica: Label = $HUDContainer/NombreCientifica

func _ready() -> void:

	await get_tree().process_frame
	visible = true
	colorrect.visible = true
	label_cientifica.visible = false
	
	animation_fade_in.play("fade_in")

	# Connect all cientifica NPCs
	var root = get_tree().current_scene
	_connect_npcs(root)

	Global.cantidad_huevos_cambiada.connect(_al_cambiar_huevos)
	$HUDContainer/PanelHuevos/Label.text = str(Global.huevos_cogidos)

	Global.door_opended.connect(_on_door_opened)
	Global.fade_out_completed.connect(_on_fade_out_completed)
	#Global.scene_ready.connect(_on_scene_ready)



func _connect_npcs(node: Node) -> void:
	#print(node)
	if node.has_signal("dialog_requested"):
		node.dialog_requested.connect(_on_dialog_requested)
	
	for child in node.get_children():
		_connect_npcs(child)


func _on_dialog_requested(npc_name: String, dialog_lines: Array = []) -> void:
	if not dialog_box.is_dialog_active():
		dialog_box.start_dialog(npc_name, dialog_lines)
	else:
		dialog_box.advance_dialog()


func _al_cambiar_huevos(nuevo_valor: int) -> void:
	$HUDContainer/PanelHuevos/Label.text = str(nuevo_valor)

func _on_door_opened(_target_scene_path) -> void:

	animation_fade_in.play_backwards("fade_in")

	await animation_fade_in.animation_finished

	Global.fade_out_completed.emit()

	animation_fade_in.play("fade_in")


func _on_fade_out_completed() -> void:
	# Wait a frame to ensure new scene is loaded
	await get_tree().process_frame
	# Reconnect NPCs in the new scene
	var root = get_tree().current_scene
	_connect_npcs(root)

#func _on_scene_ready(_target_scene_path) -> void:
#	animation_fade_in.play("fade_in")
