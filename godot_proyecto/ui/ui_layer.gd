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

	# Connect to Global dialog_requested signal
	Global.dialog_requested.connect(_on_dialog_requested)

	Global.cantidad_huevos_cambiada.connect(_al_cambiar_huevos)
	$HUDContainer/PanelHuevos/Label.text = str(Global.huevos_cogidos)

	Global.door_opended.connect(_on_door_opened)
	#Global.scene_ready.connect(_on_scene_ready)



func _on_dialog_requested(npc_name: String, dialog_lines: Array = []) -> void:
	if not dialog_box.is_dialog_active():
		dialog_box.start_dialog(npc_name, dialog_lines)
	else:
		dialog_box.advance_dialog()


func _al_cambiar_huevos(nuevo_valor: int) -> void:
	$HUDContainer/PanelHuevos/Label.text = str(nuevo_valor)

func _on_door_opened(_target_scene_path) -> void:
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.can_move = false
	
	if _target_scene_path != "res://scenes/creditos/creditos.tscn":
		animation_fade_in.play_backwards("fade_in")
	else:
		animation_fade_in.play("fade_in", -1, -0.25, true)

	await animation_fade_in.animation_finished

	Global.fade_out_completed.emit()
	if player:
		player.can_move = true
	animation_fade_in.play("fade_in")

#func _on_scene_ready(_target_scene_path) -> void:
#	animation_fade_in.play("fade_in")
