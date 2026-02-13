extends Node2D

@export var sprite_cientifica: SpriteFrames
@export var texture_cientifica: Texture
@export var npc_name: String = "curie"
@export var escala_sprite: float = 3
@export var huevos_necesarios: int = 5
@export var menu_height_offset: float = -120.0
@export var menu_background_color: Color = Color(0.2, 0.2, 0.2, 1.0)
@export var selection_border_color: Color = Color(1.0, 1.0, 0.0, 1.0)

var player_in_area: bool = false
var option_menu: Control = null
var menu_active: bool = false
var selected_option: int = 0  # 0 = Si, 1 = No
var option_buttons: Array = []
var menu_ya_procesado: bool = false
var esperando_cierre_final: bool = false
var mostrando_dialogo_agradecimiento: bool = false

# Dictionary containing all dialogs
var dialogs: Dictionary = {
	"heisenberg_prologo": [
		"h Ah, perfecto, llegas justo a tiempo.",
		"p Buenos días, profesor. Me dijo que tenía algo urgente que...",
		"h Me voy de viaje. Indefinidamente. Tú te quedas a cargo de esto.",
		"p ¿Perdón, se refiere a la granja? ¿Una beca doctoral incluye cuidar granjas?",
		"h No es una granja normal. Es una Granja Cuántica ™.",
		"p Eso... ¿qué significa exactamente?",
		"h Mejor que no lo sepas. De hecho, cuanto menos sepas, mejor funcionará todo. Es la regla número uno.",
		"p ¿Y cuánto tiempo estará fuera?",
		"h Imposible saberlo con certeza. Podría volver en una hora. O en cinco años. Depende.",
		"p ¿Depende de qué?",
		"h De si vuelvo o no.",
		"h Bueno... Bienvenido a la física cuántica. Tu trabajo es simple: recoger huevos, mantener contentos a los 'visitantes científicos', y sobre todo... No los mires demasiado fijamente.",
		"p ¿A los científicos?",
		"h A los huevos. Bueno, a ambos, la verdad. Pero especialmente a los huevos.",
		"p Profesor, esto no tiene ningún...",
		"h ¡Perfecto! Empiezas a entenderlo.",
		"h Ah, y una cosa más: la posición de los huevos solo puedes verificarla desde dentro del gallinero.",
		"h Pero la cantidad solo la sabrás desde fuera. Y ambas pueden cambiar mientras miras la otra.",
		"p Eso viola todas las leyes de...",
		"h Sí, sí. Nos vemos. O no. ¡Quién sabe!"
	],
	"curie": [
		"c ¡Ah, el nuevo asistente! Necesito tu ayuda urgentemente.",
		"p Profesora Curie, es un honor. ¿En qué puedo...?",
		"c Necesito cinco huevos. Exactamente cinco.",
		"p Claro, para un experimento supongo.",
		"c Para enseñárselos a mis amigas.",
		"p ¿Sus... amigas?",
		"c Las llamo 'partículas radiactivas'. Son preciosas. Brillan en la oscuridad.",
		"p Suena... peligroso.",
		"c Oh, mucho. Extremadamente peligroso.",
		"p ¿Mortal?",
		"c Casi con certeza.",
		"p Profesora, tal vez deberíamos...",
		"c Tranquilo. Llevo cuidado de ellas desde hace años.",
		"c Y si me ayudas con esos cinco huevos, te dejaré cuidar de una de ellas. Son... especiales.",
		"p No estoy seguro de que eso sea tranquilizador.",
		"c ¡Exacto! Nunca estés seguro de nada. Primera lección de ciencia experimental.",
		"x ",
		"c Excelente trabajo. Has demostrado gran valor. O gran ingenuidad. Probablemente ambas.",
		"c Como prometí, esta es para ti. Cuídala bien. Brilla un poco, pero es inofensiva. Probablemente.",
		"p Gracias, profesora. Ahora si me permite, necesito descansar...",
		"c ¡Perfecto! Descansa bien. Porque mañana necesitaré el doble."
	],
	"bohr": [
		"b ¡Amigo mío! Tengo un acertijo para ti.",
		"p Profesor Bohr, buenos días. ¿Qué necesita?",
		"b Necesito dos huevos. Idénticos. Pero no dos huevos separados",
		"p Por supuesto profesor, la granja está llena de huevos le traeré dos enseguida.",
		"b No, no, no. Creo que no me has entendido. Quiero dos huevos completos, idénticos, ocupando el mismo espacio al mismo tiempo.",
		"p Eso es físicamente imposible. Dos objetos no pueden estar en el mismo lugar simultáneamente...",
		"b Exacto.",
		"p ¿Exacto qué?",
		"b Es imposible. Por eso tiene sentido.",
		"p Profesor, con todo respeto, eso no tiene ningún sentido.",
		"b ¡Ahora sí lo entiendes!",
		"b La complementariedad, mi querido estudiante. Dos estados opuestos, mutuamente excluyentes, pero ambos verdaderos.",
		"b Si logras resolver este acertijo, tengo una criatura complementaria que necesita un nuevo guardián.",
		"p Está describiéndome una contradicción lógica, no un huevo.",
		"b En efecto.",
		"p Entonces, ¿qué hago exactamente?",
		"b Hazlo de todas formas. Diez huevos. En superposición perfecta.",
		"x ",
		"b ¡Magnífico!",
		"p ¿De verdad? ¿Funcionó?",
		"b Lo conseguiste perfectamente. Y también fallaste completamente.",
		"p No sé si eso es un cumplido o...",
		"b Ambas cosas. Ninguna de ellas. Depende de cómo lo mires. Estoy muy orgulloso de ti.",
		"b Y también extremadamente decepcionado.",
		"b Este pequeño es tuyo ahora. Un erizo que no puede pinchar. Fascinante, ¿verdad?",
		"p Gracias. Creo."
	],
	"dirac": [
		"d Necesito huevos.",
		"p Buenos días, profesor Dirac. ¿Cuántos exactamente?",
		"d La cantidad perfecta.",
		"p ¿Y eso serían...?",
		"d Perfecta.",
		"p Profesor, necesito un número. ¿Seis? ¿Diez? ¿Una docena?",
		"d No.",
		"d La ecuación debe balancearse. Simetría perfecta. Ni uno más, ni uno menos que la cantidad exacta requerida por el universo en este momento específico.",
		"p ¿Y cómo se supone que sepa cuál es esa cantidad?",
		"d Observación. Intuición. Matemáticas elegantes.",
		"p ¿Puede darme una pista?",
		"d ... No.",
		"d Si logras el balance perfecto, te confiaré uno de mis especímenes. Simétrico. Elegante.",
		"x ",
		"d Aceptable.",
		"p ¿Eso es todo? ¿Solo 'aceptable'?",
		"d ...",
		"d Tómalo. Es tuyo ahora.",
		"p Bueno... Muchas gracias profesor."
	],
	"schrodinger": [
		"s ¡Ah, llegas en el momento perfecto!",
		"p Profesor Schrödinger. He oído hablar de su trabajo con...",
		"s Sí, sí, el gato. Todos hablan del gato. Pero hoy hablamos de huevos.",
		"p ¿Qué necesita que haga?",
		"s No abras los huevos.",
		"p ¿Perdón?",
		"s Necesito huevos. Pero no puedes abrirlos. Ni mirarlos. Ni verificar su contenido de ninguna manera.",
		"p Pero entonces, ¿cómo sabré que son los correctos?",
		"s No lo sabrás. Esa es la belleza del asunto.",
		"s Si aceptas la incertidumbre y me traes veinte huevos sin identificar, te regalaré una de mis mascotas.",
		"p Esto es una granja, profesor. No un experimento mental.",
		"s ¿Cuál es la diferencia?",
		"p Uno produce comida. El otro produce... papers académicos.",
		"s Para mí, ambos alimentan el alma de la misma manera.",
		"x ",
		"s ¡Espléndido! Absolutamente espléndido.",
		"p ¿Funcionó? ¿Eran los huevos correctos?",
		"s No lo sé. No lo sabré nunca.",
		"p Pero... ¿entonces cómo sabe que lo hice bien?",
		"s No lo sé. Y al no saberlo, ambas posibilidades existen simultáneamente: lo hiciste perfecto, y lo hiciste terrible.",
		"s Al igual que los huevos, al no abrirlos siempre conservan todas sus posibilidades.",
		"s Aquí está tu recompensa, supongo que te la llevarás. O no. No lo sabré hasta que te vayas.",
		"p Eso no es muy útil para una evaluación.",
		"s La incertidumbre es la única certeza verdadera, mi joven amigo. Esto no es solo ciencia. Esto es arte. Poesía. Misterio.",
		"p Es profundamente frustrante es lo que es.",
		"s ¡Ahora sí lo entiendes!"
	],
	"einstein": [
		"e Veo que ya la han roto.",
		"p ¡Profesor Einstein! Yo solo seguía las instrucciones. Todos me pedían cosas imposibles y yo...",
		"e Ese fue tu error.",
		"p ¿Seguir instrucciones?",
		"e Exactamente. Las reglas de la cuántica son, en el mejor de los casos, sugerencias poco confiables.",
		"p Pero usted siempre dice que 'Dios no juega a los dados con el universo'.",
		"e Sí, y mira dónde me ha llevado esa terquedad. A discutir con Bohr durante décadas.",
		"e Este lugar... esta 'Granja Cuántica' ™... es todo lo que detesto de la mecánica cuántica hecho realidad.",
		"e Y sin embargo, aquí estamos.",
		"p Entonces, ¿qué hago? ¿Cómo arreglo esto?",
		"e No lo arreglas. Lo aceptas. O mejor aún... Imagina que existe una realidad donde todo funciona perfectamente.",
		"e Una variable oculta que explica todo este caos.",
		"p ¿Existe esa realidad?",
		"e Probablemente no. Pero es reconfortante imaginarla.",
		"p Eso no resuelve mi problema actual.",
		"e Los mejores pensamientos nunca lo hacen. ¿Sabes qué? Haz esto: imagina la solución ideal. Luego ignora todo lo demás que contradiga esa solución.",
		"p ¿Eso no es básicamente negación?",
		"e Yo lo llamo 'determinismo local'. Suena más científico.",
		"e No estoy seguro de si esto probó o refutó mi teoría. Pero fue educativo.",
		"p ¿Eso es bueno?",
		"e En ciencia, la confusión productiva es mejor que la certeza estéril. Aunque admito preferir la realidad intacta."
	],
	"heisenberg_final": [
		"h ¡Volví!",
		"p Profesor... bienvenido de vuelta.",
		"h Veo que todo sigue en pie.",
		"p Más o menos.",
		"h ¿Hubo problemas?",
		"p Los científicos que dejó encargados casi destruyen el espacio-tiempo pidiendo huevos imposibles.",
		"h Ah, sí. A veces hacen eso, debí advertírtelo.",
		"p ¿ESO CREE?",
		"h Pero estás vivo. La granja existe. En alguna forma o estado observable. Eso es todo lo que importa.",
		"p La mitad de los gallineros existe en dos lugares al mismo tiempo.",
		"p Dirac no me ha hablado en tres días. Y creo que Schrödinger ha encerrado algo en una caja que no deberíamos abrir jamás pero sinceramente, no se cual de ellas es.",
		"h Perfecto.",
		"p ¿Perfecto?",
		"h Eso significa que funcionó. Si todo estuviera normal, habrías fallado.",
		"p Tengo tantas preguntas...",
		"h Y yo tengo cero respuestas concretas. Bienvenido permanentemente a la cuántica. Por cierto, ¿aprendiste algo de todo esto?",
		"p Que la realidad es negociable.",
		"h Aprobarás tu tesis doctoral sin problemas."
	]
}


func _ready() -> void:

	$Visual/AnimatedSprite2D.sprite_frames = sprite_cientifica
	#$AnimatedSprite2D.apply_scale(Vector2(0.1, 0.1))
	#$AnimatedSprite2D.play("default")
	$Visual/Sprite2D.texture = texture_cientifica
	apply_size_multiplier()
	
	# Create option menu
	_create_option_menu()
	
	# Connect to Global signals
	Global.interact.connect(_on_player_interact)
	Global.dialog_finished.connect(_on_dialog_finished)
	Global.dialog_menu_requested.connect(_on_dialog_menu_requested)
	Global.quit.connect(_on_quit_pressed)

	await get_tree().create_timer(randf()).timeout
	$Visual/AnimationPlayer.play("talk")


func _on_player_interact() -> void:
	if menu_active:
		# Interact selects current option
		# Check which button is actually selected based on visibility
		var option = "no"  # Default to "no"
		if selected_option == 0 and option_buttons.size() > 0 and option_buttons[0].visible:
			option = "si"
		_on_option_selected(option)
		return
	
	var bodies = $AreaDialogo.get_overlapping_bodies()
	for body in bodies:
		if body is CharacterBody2D:
			var dialog_lines = dialogs.get(npc_name, [])
			Global.dialog_requested.emit(npc_name, dialog_lines)
			break


func _create_option_menu() -> void:
	# Create CanvasLayer to ensure menu is always on top
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100  # High layer to be on top of everything
	
	# Create container for menu
	option_menu = Control.new()
	
	var vbox = VBoxContainer.new()
	vbox.position = Vector2(-50, 0)
	
	# Create "Si" button
	var btn_si = Button.new()
	btn_si.text = "Los tengo"
	btn_si.custom_minimum_size = Vector2(100, 40)
	# Create style for normal state (no border)
	var style_normal_si = StyleBoxFlat.new()
	style_normal_si.bg_color = Color(0.3, 0.3, 0.3, 1.0)
	style_normal_si.set_corner_radius_all(3)
	btn_si.add_theme_stylebox_override("normal", style_normal_si)
	btn_si.add_theme_stylebox_override("hover", style_normal_si)
	btn_si.add_theme_stylebox_override("pressed", style_normal_si)
	btn_si.add_theme_stylebox_override("focus", style_normal_si)
	option_buttons.append(btn_si)
	vbox.add_child(btn_si)
	
	# Create "No" button
	var btn_no = Button.new()
	btn_no.text = "Aún no los tengo"
	btn_no.custom_minimum_size = Vector2(100, 40)
	# Create style for normal state (no border)
	var style_normal_no = StyleBoxFlat.new()
	style_normal_no.bg_color = Color(0.3, 0.3, 0.3, 1.0)
	style_normal_no.set_corner_radius_all(3)
	btn_no.add_theme_stylebox_override("normal", style_normal_no)
	btn_no.add_theme_stylebox_override("hover", style_normal_no)
	btn_no.add_theme_stylebox_override("pressed", style_normal_no)
	btn_no.add_theme_stylebox_override("focus", style_normal_no)
	option_buttons.append(btn_no)
	vbox.add_child(btn_no)
	
	option_menu.add_child(vbox)
	canvas_layer.add_child(option_menu)
	add_child(canvas_layer)
	option_menu.hide()


func _on_dialog_finished(finished_npc_name: String) -> void:
	# Si estamos esperando el cierre final después de aceptar, cerrar ahora
	if finished_npc_name == npc_name and esperando_cierre_final:
		esperando_cierre_final = false
		menu_ya_procesado = false
		Global.menu_closed.emit()
		return
	
	if name == "Heisenberg":
		Global.hablado_con_heis = true
	elif name == "Einstein":
		Global.hablado_con_eins = true
	
	if Global.hablado_con_heis and Global.hablado_con_eins:
		Global.final.emit()
	
	# Only show menu if this is the NPC that finished talking AND menu hasn't been processed yet
	#if finished_npc_name == npc_name and not menu_ya_procesado:
	#	menu_active = true
	#	
	#	# Check if player has enough eggs
	#	var tiene_suficientes_huevos = Global.huevos_cogidos >= huevos_necesarios
	#	
	#	# Check if this cientifica has already been accepted
	#	var ya_aceptada = Global.cientificas_aceptadas.get(npc_name, false)
	#	
	#	# Hide "Si" button if not enough eggs OR if already accepted
	#	if option_buttons.size() > 0:
	#		option_buttons[0].visible = tiene_suficientes_huevos and not ya_aceptada
	#	
	#	# Set initial selection based on available options
	#	selected_option = 0 if (tiene_suficientes_huevos and not ya_aceptada) else 1
	#	
	#	_update_option_highlight()
	#	option_menu.show()
	#	# Emitir señal de menú abierto
	#	Global.menu_opened.emit()
	
	# Reset the flag for next conversation
	if finished_npc_name == npc_name:
		menu_ya_procesado = false


func _on_option_selected(option: String) -> void:
	menu_active = false
	option_menu.hide()
	
	if option == "si":
		# Si se seleccionó "Si", restar huevos necesarios y marcar como aceptada
		Global.huevos_cogidos -= huevos_necesarios
		Global.cientificas_aceptadas[npc_name] = true
		Global.cientificas_aceptadas_changed.emit()
		menu_ya_procesado = true
		# NO emitir menu_closed todavía, esperar a que termine el diálogo
		esperando_cierre_final = true
		Global.dialog_continue_requested.emit()
	elif option == "no":
		# Si se seleccionó "No", cerrar el diálogo inmediatamente
		menu_ya_procesado = true
		Global.menu_closed.emit()
		Global.dialog_close_requested.emit()
	
	print("Option selected: ", option, " for NPC: ", npc_name)


func _process(_delta: float) -> void:
	if menu_active:
		# Update menu position to follow the scientist in screen space
		var screen_pos = get_viewport().get_canvas_transform() * global_position
		option_menu.position = screen_pos + Vector2(0, menu_height_offset)
		
		# Check for up/down input
		if Input.is_action_just_pressed("move_character_up"):
			# Skip invisible buttons
			var new_option = selected_option - 1
			while new_option >= 0 and not option_buttons[new_option].visible:
				new_option -= 1
			if new_option >= 0:
				selected_option = new_option
				_update_option_highlight()
		elif Input.is_action_just_pressed("move_character_down"):
			# Skip invisible buttons
			var new_option = selected_option + 1
			while new_option < option_buttons.size() and not option_buttons[new_option].visible:
				new_option += 1
			if new_option < option_buttons.size():
				selected_option = new_option
				_update_option_highlight()


func _update_option_highlight() -> void:
	# Highlight selected option with border
	for i in range(option_buttons.size()):
		var btn = option_buttons[i]
		if i == selected_option:
			# Create style with border for selected option
			var style_selected = StyleBoxFlat.new()
			style_selected.bg_color = Color(0.3, 0.3, 0.3, 1.0)
			style_selected.set_corner_radius_all(3)
			style_selected.border_color = selection_border_color
			style_selected.set_border_width_all(3)
			btn.add_theme_stylebox_override("normal", style_selected)
			btn.add_theme_stylebox_override("hover", style_selected)
			btn.add_theme_stylebox_override("pressed", style_selected)
			btn.add_theme_stylebox_override("focus", style_selected)
		else:
			# Create style without border for non-selected option
			var style_normal = StyleBoxFlat.new()
			style_normal.bg_color = Color(0.3, 0.3, 0.3, 1.0)
			style_normal.set_corner_radius_all(3)
			btn.add_theme_stylebox_override("normal", style_normal)
			btn.add_theme_stylebox_override("hover", style_normal)
			btn.add_theme_stylebox_override("pressed", style_normal)
			btn.add_theme_stylebox_override("focus", style_normal)


func _on_dialog_menu_requested(npc_name_from_dialog: String) -> void:
	# Esta función se llama cuando se detecta una línea con 'x' en el diálogo
	if npc_name_from_dialog == npc_name:
		menu_active = true
		
		# Check if player has enough eggs
		var tiene_suficientes_huevos = Global.huevos_cogidos >= huevos_necesarios
		
		# Check if this cientifica has already been accepted
		var ya_aceptada = Global.cientificas_aceptadas.get(npc_name, false)
		
		# Hide "Si" button if not enough eggs OR if already accepted
		if option_buttons.size() > 0:
			option_buttons[0].visible = tiene_suficientes_huevos and not ya_aceptada
		
		# Set initial selection based on available options
		selected_option = 0 if (tiene_suficientes_huevos and not ya_aceptada) else 1
		
		_update_option_highlight()
		option_menu.show()
		# Emitir señal de menú abierto
		Global.menu_opened.emit()
		# Ya no necesitamos procesar en dialog_finished porque se procesa aquí
		menu_ya_procesado = true


func _on_quit_pressed() -> void:
	if menu_active:
		# Quit directly selects "No"
		_on_option_selected("no")

func apply_size_multiplier() -> void:
	
	# Aplicar escala a los sprites
	var sprite_node = $Visual/Sprite2D
	var animated_sprite = $Visual/AnimatedSprite2D
	
	if sprite_node:
		sprite_node.scale = Vector2.ONE * escala_sprite
	if animated_sprite:
		animated_sprite.scale = Vector2.ONE * escala_sprite
