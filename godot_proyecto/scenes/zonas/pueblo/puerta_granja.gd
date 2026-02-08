extends Area2D

@export_file("*.tscn") var target_scene_path: String

var player: CharacterBody2D
var player_in_area: bool = false
var root

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	root = get_tree().current_scene
	_search_player_recursively(root)

	print("primer player", player)
	if not player:
		player = get_node_or_null("/root/Personaje")
		print("segundo player", player)
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
	var bodies = get_overlapping_bodies()
	if player in bodies:
		get_tree().change_scene_to_file(target_scene_path)
