extends Node


# Scenes

signal cantidad_huevos_cambiada(nuevo_valor: int)
signal cambiar_avatar_dialogo(personaje_id: String)

signal door_opended(target_scene_path: String)
signal fade_out_completed

signal interact
signal quit
signal dialog_finished(npc_name: String)
signal menu_opened
signal menu_closed
signal change_move(can_move: bool)


# Vars

var root
var ui
var ui_container
var huevos: int = 0
var huevos_cogidos: int = 0:
	set(value):
		huevos_cogidos = value
		cantidad_huevos_cambiada.emit(huevos_cogidos)
