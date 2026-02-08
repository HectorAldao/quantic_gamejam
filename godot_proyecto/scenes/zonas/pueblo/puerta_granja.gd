extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().current_scene
	_search_player_recursively(root)

	print("primer player", player)
	if not player:
		player = get_node_or_null("/root/Personaje")
		print("segundo player", player)
	if player:
		player.interact.connect(_on_player_interact)
		print("player conectado")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
