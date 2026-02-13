#extends Control
#
#func _ready() -> void:
#	UiLayer.get_node("HUDContainer/PanelHuevos").visible = false
#	
#	# Obtener referencias a los botones de la escena
#	var btn_jugar = $CentroMenu/Jugar
#	var btn_sin_tutorial = $CentroMenu/JugarNoTuto
#	
#	# Conectar las señales de los botones
#	btn_jugar.pressed.connect(_on_jugar_pressed)
#	btn_sin_tutorial.pressed.connect(_on_jugar_sin_tutorial_pressed)
#	
#	# Establecer el foco inicial
#	btn_jugar.grab_focus()
#
## Callbacks de lógica de negocio
#func _on_jugar_pressed() -> void:
#	await _start_game_with_fade("res://scenes/zonas/pueblo/pueblo.tscn")
#
#func _on_jugar_sin_tutorial_pressed() -> void:
#	Global.tutorial_was_played = true
#	await _start_game_with_fade("res://scenes/zonas/pueblo/pueblo.tscn")
#
#func _start_game_with_fade(scene_path: String) -> void:
#	# Guardar referencia al árbol ANTES del await
#	var tree = get_tree()
#	
#	# Emitir señal de puerta abierta para activar fade out
#	Global.door_opended.emit(scene_path)
#	
#	# Esperar a que termine el fade out
#	await Global.fade_out_completed
#
#	UiLayer.get_node("HUDContainer/PanelHuevos").visible = true
#	
#	# Usar la referencia guardada
#	tree.change_scene_to_file(scene_path)

################################

extends Control

var menu_options: Array = []
var current_selection: int = 0

func _ready() -> void:
	
	UiLayer.get_node("HUDContainer/PanelHuevos").visible = false

	# Obtener referencia al nodo CentroMenu
	#var centro_menu = get_node("VBoxContainer/CentroMenu")
	var centro_menu = get_node("CentroMenu")
	
	# Crear contenedor para el menú
	var menu_container = VBoxContainer.new()
	menu_container.mouse_filter = Control.MOUSE_FILTER_PASS # Permite que el input llegue a los botones
	
	# Configurar anchors para centrar el contenedor con respecto a CentroMenu
	menu_container.anchor_left = 0.5
	menu_container.anchor_right = 0.5
	menu_container.anchor_top = 0.5
	menu_container.anchor_bottom = 0.5
	menu_container.grow_horizontal = Control.GROW_DIRECTION_BOTH
	menu_container.grow_vertical = Control.GROW_DIRECTION_BOTH
	menu_container.offset_left = -150  # La mitad del ancho del botón (300/2)
	menu_container.offset_right = 150
	menu_container.offset_top = -65  # Ajustado para centrar verticalmente
	menu_container.offset_bottom = 65
	
	menu_container.add_theme_constant_override("separation", 20)
	centro_menu.add_child(menu_container)
	
	# Crear opciones del menú
	var option1 = create_menu_option("Jugar")
	var option2 = create_menu_option("Jugar sin intro")
	
	menu_container.add_child(option1)
	menu_container.add_child(option2)
	
	menu_options.append(option1)
	menu_options.append(option2)
	
	# Resaltar primera opción
	update_selection()


func create_menu_option(text: String) -> Button:
	var button = Button.new()
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.text = text
	button.flat = false
	button.add_theme_font_size_override("font_size", 32)
	button.custom_minimum_size = Vector2(300, 50)
	
	# Crear StyleBox con contorno
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = Color(0.015, 0.05, 0.2, 0.9)
	style_normal.border_width_left = 2
	style_normal.border_width_right = 2
	style_normal.border_width_top = 2
	style_normal.border_width_bottom = 2
	style_normal.border_color = Color(0.025, 0.08, 0.32, 1.0)
	style_normal.corner_radius_top_left = 5
	style_normal.corner_radius_top_right = 5
	style_normal.corner_radius_bottom_left = 5
	style_normal.corner_radius_bottom_right = 5
	
	var style_hover = StyleBoxFlat.new()
	style_hover.bg_color = Color(0.3, 0.3, 0.3, 0.9)
	style_hover.border_width_left = 3
	style_hover.border_width_right = 3
	style_hover.border_width_top = 3
	style_hover.border_width_bottom = 3
	style_hover.border_color = Color("E9429D") 
	style_hover.corner_radius_top_left = 5
	style_hover.corner_radius_top_right = 5
	style_hover.corner_radius_bottom_left = 5
	style_hover.corner_radius_bottom_right = 5
	
	button.add_theme_stylebox_override("normal", style_normal)
	button.add_theme_stylebox_override("hover", style_hover)
	button.add_theme_stylebox_override("pressed", style_hover)
	
	# Conectar señales
	button.mouse_entered.connect(_on_option_mouse_entered.bind(button))
	button.pressed.connect(_on_option_pressed.bind(button))
	
	return button


func update_selection() -> void:
	for i in range(menu_options.size()):
		if i == current_selection:
			menu_options[i].modulate = Color("E9429D")  # Amarillo
		else:
			menu_options[i].modulate = Color(1.0, 1.0, 1.0)  # Blanco


func _on_option_mouse_entered(button: Button) -> void:
	current_selection = menu_options.find(button)
	update_selection()


func _on_option_pressed(button: Button) -> void:
	current_selection = menu_options.find(button)
	_select_current_option()


func _input(event: InputEvent) -> void:
	# Navegación con teclas de movimiento
	if event.is_action_pressed("move_character_up") or event.is_action_pressed("ui_up"):
		current_selection = (current_selection - 1 + menu_options.size()) % menu_options.size()
		update_selection()
	elif event.is_action_pressed("move_character_down") or event.is_action_pressed("ui_down"):
		current_selection = (current_selection + 1) % menu_options.size()
		update_selection()
	
	# Selección con tecla de interactuar
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		_select_current_option()


func _select_current_option() -> void:
	match current_selection:
		0:  # Jugar
			await _start_game_with_fade("res://scenes/zonas/pueblo/pueblo.tscn")
		1:  # Jugar sin tutorial
			Global.tutorial_was_played = true
			await _start_game_with_fade("res://scenes/zonas/pueblo/pueblo.tscn")


func _start_game_with_fade(scene_path: String) -> void:
	# Guardar referencia al árbol ANTES del await
	var tree = get_tree()
	
	# Emitir señal de puerta abierta para activar fade out
	Global.door_opended.emit(scene_path)
	
	# Esperar a que termine el fade out
	await Global.fade_out_completed

	UiLayer.get_node("HUDContainer/PanelHuevos").visible = true
	
	# Usar la referencia guardada
	tree.change_scene_to_file(scene_path)
