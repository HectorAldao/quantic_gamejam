extends Node2D


var player_in_area: bool = false

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
			queue_free()

			if entero_random != 0:
				Global.huevos_cogidos += 1
			break



func _process(_delta: float) -> void:
	pass
