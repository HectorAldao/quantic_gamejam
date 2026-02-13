extends Node


# Scenes

signal dialog_requested(npc_name: String, dialog_lines: Array)
signal dialog_menu_requested(npc_name: String)
signal dialog_close_requested()
signal dialog_continue_requested()
signal cantidad_huevos_cambiada(nuevo_valor: int)
signal cambiar_avatar_dialogo(personaje_id: String)
signal cientificas_aceptadas_changed()

signal door_opended(target_scene_path: String)
signal fade_out_completed

signal interact
signal quit
signal dialog_finished(npc_name: String)
signal menu_opened
signal menu_closed
signal change_move(can_move: bool)

signal final


# Vars

var tutorial_was_played: bool = false
var root
var ui
var ui_container
var huevos: int = 0
var huevos_cogidos: int = 0:
	set(value):
		huevos_cogidos = value
		cantidad_huevos_cambiada.emit(huevos_cogidos)

# Dictionary to track which cientificas have been accepted already
var cientificas_aceptadas: Dictionary = {}
var from_final: bool = false

var hablado_con_eins: bool = false
var hablado_con_heis: bool = false
