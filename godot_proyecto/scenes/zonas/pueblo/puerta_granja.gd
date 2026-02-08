extends Area2D

var player: CharacterBody2D
var player_in_area: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
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
	if player_in_area:
		get_tree().change_scene_to_file("res://scenes/zonas/granja/granja.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
