extends Node


# Scenes

signal cantidad_huevos_cambiada(nuevo_valor: int)

signal door_opended(target_scene_path: String)
signal fade_out_completed


# Vars

var root
var ui
var ui_container
var huevos: int = 0
var huevos_cogidos: int = 0:
	set(value):
		huevos_cogidos = value
		cantidad_huevos_cambiada.emit(huevos_cogidos)

