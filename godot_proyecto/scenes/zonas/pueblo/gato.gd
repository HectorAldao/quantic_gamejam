extends Node2D

@export var sprite_gato: Texture
@export var sprite_caja: Texture
@export var sprite_patas: Texture

@onready var area_interaccion: Area2D = $Area2D

var entero_random: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	entero_random = rng.randi_range(0, 2)
	
	if entero_random == 0:
		$Sprite2D.texture = sprite_gato
	elif entero_random == 1:
		$Sprite2D.texture = sprite_caja
	elif entero_random == 2:
		$Sprite2D.texture = sprite_patas
		
	Global.interact.connect(_miau)


func _miau() -> void:
	for body in area_interaccion.get_overlapping_bodies():
		if body is CharacterBody2D and entero_random != 1:
			$AudioStreamPlayer2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
