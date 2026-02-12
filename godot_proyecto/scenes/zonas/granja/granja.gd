extends Node2D

@export var huevo_cuantico: PackedScene
@onready var spawn_area: ReferenceRect = $SpawnArea

var entero_random: int = 0

func _ready() -> void:

	$Huevos.huevos = Global.huevos
	
	# Establecer sprite inicial del personaje mirando arriba
	var personaje = get_tree().get_first_node_in_group("player")
	if personaje:
		personaje.sprite_2d.texture = personaje.pj_arrib

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	entero_random = rng.randi_range(-2, 2)

	var num_huevos: int = max(0, $Huevos.huevos + entero_random)
	
	for i in range(num_huevos):
		spawn_instance()

func spawn_instance() -> void:

	var instance = huevo_cuantico.instantiate()
	
	# Obtener límites globales del ReferenceRect
	var area_pos = spawn_area.global_position
	var area_size = spawn_area.size
	
	# Calcular posición aleatoria dentro del rectángulo
	var random_x = randf_range(area_pos.x, area_pos.x + area_size.x)
	var random_y = randf_range(area_pos.y, area_pos.y + area_size.y)
	
	instance.global_position = Vector2(random_x, random_y)
	add_child(instance)
