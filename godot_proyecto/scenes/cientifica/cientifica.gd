extends Node2D

@export var sprite_cientifica: SpriteFrames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = sprite_cientifica
	$AnimatedSprite2D.apply_scale(Vector2(0.1, 0.1))
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
