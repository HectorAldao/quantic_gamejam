extends Area2D

@export_file("*.tscn") var target_scene_path: String

var player_in_area: bool = false
var atravesada: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to Global interact signal
	Global.interact.connect(_on_player_interact)


func _on_player_interact() -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is CharacterBody2D and not atravesada:
			atravesada = true
			# Guardar datos en el Global antes de salir
			var old_scene = get_tree().current_scene
			
			if old_scene.name == "Pueblo":
				Global.huevos = int($"../Huevos/HuevosLabel".text)
			elif old_scene.name == "Granja":
				Global.huevos = $"../Huevos".huevos
			
			Global.door_opended.emit(target_scene_path)
			
			$AudioStreamPlayer2D.play()
			
			#print(get_tree().current_scene.name)
			if get_tree().current_scene.name == "Final":
				Global.from_final = true
			
			# Esperar a que se emita la señal
			await Global.fade_out_completed

			get_tree().change_scene_to_file(target_scene_path)
			break


func _on_change_scene_request() -> void:
	get_tree().change_scene_to_file(target_scene_path)
