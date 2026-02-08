extends Node2D

signal dialog_requested(npc_name: String)

@export var sprite_cientifica: SpriteFrames
@export var npc_name: String = "curie"

var player: CharacterBody2D
var player_in_area: bool = false

func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = sprite_cientifica
	$AnimatedSprite2D.apply_scale(Vector2(0.1, 0.1))
	$AnimatedSprite2D.play("default")
	
	# Connect area signals
	$AreaDialogo.body_entered.connect(_on_body_entered)
	$AreaDialogo.body_exited.connect(_on_body_exited)
	
	# Find player and connect to interact signal
	var root = get_tree().current_scene
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


func _on_body_entered(_body: Node2D) -> void:
	player_in_area = true


func _on_body_exited(_body: Node2D) -> void:
	player_in_area = false


func _on_player_interact() -> void:
	print("player interacted")
	if player_in_area:
		dialog_requested.emit(npc_name)
