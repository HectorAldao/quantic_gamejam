extends Node2D

signal dialog_requested(npc_name: String, dialog_lines: Array)

@export var sprite_cientifica: SpriteFrames
@export var npc_name: String = "curie"

var player: CharacterBody2D
var player_in_area: bool = false

# Dictionary containing all dialogs
var dialogs: Dictionary = {
	"curie": [
		"Hola",
		"Un experimento dejó así a mi gallina",
		"La quieres?"
	],
	"schrodinger": [
		"Hola",
		"Un experimento dejó así a mi gato",
		"Lo quieres?"
	]
}

func _ready() -> void:

	$AnimatedSprite2D.sprite_frames = sprite_cientifica
	$AnimatedSprite2D.apply_scale(Vector2(0.1, 0.1))
	$AnimatedSprite2D.play("default")
	
	# Find player and connect to interact signal
	var root = get_tree().current_scene
	_search_player_recursively(root)

	if player:
		player.interact.connect(_on_player_interact)
	

func _search_player_recursively(node: Node) -> void:
	if node.has_signal("interact"):
		player = node
		return
	for child in node.get_children():
		_search_player_recursively(child)


func _on_player_interact() -> void:
	var bodies = $AreaDialogo.get_overlapping_bodies()
	if player in bodies:
		var dialog_lines = dialogs.get(npc_name, [])
		dialog_requested.emit(npc_name, dialog_lines)
