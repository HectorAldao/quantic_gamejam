extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Reproducir fade_in antes de ocultar el HUD
	await get_tree().process_frame
	
	# Asegurar que el ColorRect del fade está visible
	var color_rect = UiLayer.get_node("HUDContainer/ColorRect")
	var animation_player = UiLayer.get_node("HUDContainer/ColorRect/AnimationPlayer")
	
	color_rect.visible = true
	animation_player.play("fade_in")
	
	# Ocultar el resto del HUD pero mantener el fade visible
	UiLayer.get_node("HUDContainer/DialogBox").visible = false
	UiLayer.get_node("HUDContainer/PanelHuevos").visible = false
	UiLayer.get_node("HUDContainer/NombreCientifica").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
