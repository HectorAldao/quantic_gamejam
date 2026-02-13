extends Node2D

@export var sonidos_huevo_cogido: Array[AudioStream] = []
@export var sonidos_huevo_no_cogido: Array[AudioStream] = []

var player_in_area: bool = false
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

# Entero aleatorio entre 0 y 2 (inclusive)
var entero_random: int = 0

func _ready() -> void:

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	entero_random = rng.randi_range(0, 2)

	# Connect to Global interact signal
	Global.interact.connect(_on_player_interact)


func _on_player_interact() -> void:
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body is CharacterBody2D:
			var asp = $AudioStreamPlayer2D
			if entero_random != 0:
				Global.huevos_cogidos += 1
				animation_player.play("obtenido")
				asp.stream = sonidos_huevo_cogido[randi() % sonidos_huevo_cogido.size()]
			else:
				animation_player.play("quantic_fade_out")
				asp.stream = sonidos_huevo_no_cogido[randi() % sonidos_huevo_no_cogido.size()]
				
			asp.play()
			
			await animation_player.animation_finished
			queue_free()
		
			break


func _process(_delta: float) -> void:
	pass
