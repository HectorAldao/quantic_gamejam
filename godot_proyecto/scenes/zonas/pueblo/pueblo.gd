extends Node2D

func _ready() -> void:
	Global.huevos = 0
	$Huevos/HuevosLabel.text = str(Global.huevos)
