extends Control

@onready var label = $Label
@onready var nombre_cientifica_label = UiLayer.get_node("HUDContainer/NombreCientifica")
@onready var label_siguiente = $LabelSiguiente
@onready var label_saltar = $LabelSaltar

var current_npc: String = ""
var current_dialog_index: int = 0
var current_dialog_list: Array = []
var waiting_for_menu: bool = false

# Diccionario de nombres de científicas según su ID
var nombres_cientificas: Dictionary = {
	"c": "Marie Curie",
	"s": "Schrödinger",
	"h": "Heisenberg",
	"d": "Dirac",
	"b": "Bohr"
}

func _ready() -> void:
	# Hide dialog box initially
	hide()
	#label.custom_minimum_size.x = 300
	
	# Connect to Global signals
	Global.quit.connect(_on_quit)
	Global.menu_opened.connect(_on_menu_opened)
	Global.menu_closed.connect(_on_menu_closed)
	Global.dialog_finished.connect(_on_dialog_finished_check)
	Global.dialog_continue_requested.connect(_on_dialog_continue_requested)
	Global.dialog_close_requested.connect(_on_dialog_close_requested)


func start_dialog(npc_name: String, dialog_lines: Array = []) -> void:
	if dialog_lines.size() > 0:
		current_npc = npc_name
		current_dialog_list = dialog_lines
		current_dialog_index = 0
		# Asegurar que LabelSaltar sea visible al inicio
		label_saltar.visible = true
		show_current_dialog()
		show()
		Global.change_move.emit(false)


func show_current_dialog() -> void:
	if current_dialog_index < current_dialog_list.size():
		var dialog_line = current_dialog_list[current_dialog_index]
		
		# Ocultar LabelSaltar en el último diálogo
		if current_dialog_index == current_dialog_list.size() - 1:
			label_saltar.visible = false
		
		# Extraer primera letra (personaje) y emitir señal
		if dialog_line.length() > 0:
			var personaje_id = dialog_line.substr(0, 1)
			
			# Si es 'x', pausar el diálogo y mostrar menú
			if personaje_id == "x":
				# Ocultar la caja de diálogo temporalmente
				#hide()
				# Emitir señal para mostrar menú
				Global.dialog_menu_requested.emit(current_npc)
				return
			
			Global.cambiar_avatar_dialogo.emit(personaje_id)
			
			# Actualizar nombre de científica y visibilidad de la etiqueta
			if nombres_cientificas.has(personaje_id):
				# Es una científica - mostrar etiqueta con su nombre
				nombre_cientifica_label.text = nombres_cientificas[personaje_id]
				nombre_cientifica_label.visible = true
			else:
				# Es el protagonista u otro - ocultar etiqueta
				nombre_cientifica_label.visible = false
			
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
		# Ocultar etiqueta de nombre al finalizar diálogo
		nombre_cientifica_label.visible = false
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
		# Buscar la línea con "x" (donde aparece el menú)
		var menu_index = -1
		for i in range(current_dialog_list.size()):
			var line = current_dialog_list[i]
			if line.length() > 0 and line[0] == "x":
				menu_index = i
				break
		
		# Siempre saltar a la línea anterior de la "x" si existe
		# Si no se encontró la "x", saltar a la última línea
		if menu_index > 0:
			# Saltar a la línea previa a la "x"
			current_dialog_index = menu_index - 1
		else:
			# No hay "x", saltar a la última línea
			current_dialog_index = current_dialog_list.size() - 1
		show_current_dialog()


func _on_menu_opened() -> void:
	waiting_for_menu = false


func _on_menu_closed() -> void:
	Global.change_move.emit(true)


func _on_dialog_finished_check(_npc_name: String) -> void:
	pass  # Solo para evitar warnings


func _on_dialog_continue_requested() -> void:
	# Continuar con el diálogo después de seleccionar 'si' en el menú
	# Saltar la línea 'x' y continuar
	current_dialog_index += 1
	if current_dialog_index < current_dialog_list.size():
		show()
		show_current_dialog()
	else:
		# Si no hay más diálogos, terminar
		hide()
		nombre_cientifica_label.visible = false
		var finished_npc = current_npc
		current_npc = ""
		current_dialog_index = 0
		current_dialog_list = []
		Global.dialog_finished.emit(finished_npc)
		Global.change_move.emit(true)


func _on_dialog_close_requested() -> void:
	# Cerrar el diálogo completamente
	hide()
	nombre_cientifica_label.visible = false
	var finished_npc = current_npc
	current_npc = ""
	current_dialog_index = 0
	current_dialog_list = []
	Global.change_move.emit(true)
