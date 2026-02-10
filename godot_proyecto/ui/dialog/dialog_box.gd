extends Control

@onready var label = $Label

var current_npc: String = ""
var current_dialog_index: int = 0
var current_dialog_list: Array = []
var waiting_for_menu: bool = false

func _ready() -> void:
	# Hide dialog box initially
	hide()
	#label.custom_minimum_size.x = 300
	
	# Connect to Global signals
	Global.quit.connect(_on_quit)
	Global.menu_opened.connect(_on_menu_opened)
	Global.menu_closed.connect(_on_menu_closed)
	Global.dialog_finished.connect(_on_dialog_finished_check)


func start_dialog(npc_name: String, dialog_lines: Array = []) -> void:
	if dialog_lines.size() > 0:
		current_npc = npc_name
		current_dialog_list = dialog_lines
		current_dialog_index = 0
		show_current_dialog()
		show()
		Global.change_move.emit(false)


func show_current_dialog() -> void:
	if current_dialog_index < current_dialog_list.size():
		var dialog_line = current_dialog_list[current_dialog_index]
		
		# Extraer primera letra (personaje) y emitir señal
		if dialog_line.length() > 0:
			var personaje_id = dialog_line.substr(0, 1)
			Global.cambiar_avatar_dialogo.emit(personaje_id)
			
			# Eliminar primera letra y espacio del texto mostrado
			if dialog_line.length() > 2 and dialog_line[1] == " ":
				label.text = dialog_line.substr(2)
			else:
				label.text = dialog_line.substr(1)
		else:
			label.text = dialog_line


func advance_dialog() -> void:
	current_dialog_index += 1
	if current_dialog_index < current_dialog_list.size():
		show_current_dialog()
	else:
		# Dialog finished
		hide()
		var finished_npc = current_npc
		current_npc = ""
		current_dialog_index = 0
		current_dialog_list = []
		# Esperar un frame para ver si se abre un menú
		waiting_for_menu = true
		# Emitir señal de diálogo terminado
		Global.dialog_finished.emit(finished_npc)
		await get_tree().create_timer(0.05).timeout
		if waiting_for_menu:
			# No se abrió menú, reactivar movimiento
			Global.change_move.emit(true)
			waiting_for_menu = false


func is_dialog_active() -> bool:
	return visible


func _on_quit() -> void:
	if is_dialog_active() and current_dialog_list.size() > 0:
		# Saltar a la última línea del diálogo
		current_dialog_index = current_dialog_list.size() - 1
		show_current_dialog()


func _on_menu_opened() -> void:
	waiting_for_menu = false


func _on_menu_closed() -> void:
	Global.change_move.emit(true)


func _on_dialog_finished_check(_npc_name: String) -> void:
	pass  # Solo para evitar warnings
