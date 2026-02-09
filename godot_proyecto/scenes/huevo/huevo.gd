extends Node2D


var player: CharacterBody2D
var player_in_area: bool = false
var root

# Entero aleatorio entre 0 y 2 (inclusive)
var entero_random: int = 0

func _ready() -> void:

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	entero_random = rng.randi_range(0, 2)

	root = get_tree().current_scene
	_search_player_recursively(root)

	if player:
		player.interact.connect(_on_player_interact)
		print("player conectado")


func _search_player_recursively(node: Node) -> void:
	if node.has_signal("interact"):
		player = node
		return
	for child in node.get_children():
		_search_player_recursively(child)


func _on_player_interact() -> void:
	var bodies = $Area2D.get_overlapping_bodies()
	if player in bodies:
		queue_free()

		if entero_random != 0:
			Global.huevos_cogidos += 1



func _process(_delta: float) -> void:
	pass
