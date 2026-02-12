extends Node2D

var tutorial_active: bool = false

# Dictionary containing tutorial dialog
var dialogs: Dictionary = {
	"heisenberg_tutorial": [
		"h Ah, perfecto, llegas justo a tiempo.",
		"p Buenos días, profesor. Me dijo que tenía algo urgente que...",
		"h Me voy de viaje. Indefinidamente. Tú te quedas a cargo de esto.",
		"p ¿Perdón, se refiere a la granja? ¿Una beca doctoral incluye cuidar granjas?",
		"h No es una granja normal. Es una Granja Cuántica TM.",
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
	]
}

func _ready() -> void:
	Global.huevos = 0
	$Huevos/HuevosLabel.text = str(Global.huevos)
	
	# Iniciar tutorial si no se ha reproducido
	if not Global.tutorial_was_played:
		tutorial_active = true
		# Conectar a las señales necesarias para manejar el tutorial
		Global.interact.connect(_on_tutorial_interact)
		Global.dialog_finished.connect(_on_dialog_finished)
		
		var dialog_lines = dialogs.get("heisenberg_tutorial", [])
		Global.dialog_requested.emit("heisenberg", dialog_lines)
	else:
		$Haisenberg.visible = false


func _on_tutorial_interact() -> void:
	if tutorial_active:
		# Avanzar el diálogo del tutorial
		var dialog_lines = dialogs.get("heisenberg_tutorial", [])
		Global.dialog_requested.emit("heisenberg", dialog_lines)


func _on_dialog_finished(npc_name: String) -> void:
	# Solo procesar si el tutorial está activo y el NPC es heisenberg
	if tutorial_active and npc_name == "heisenberg":
		tutorial_active = false
		$Haisenberg/AnimationPlayer.play("run")
		await $Haisenberg/AnimationPlayer.animation_finished
		$Haisenberg.visible = false

		Global.tutorial_was_played = true
		# Desconectar de las señales
		Global.interact.disconnect(_on_tutorial_interact)
		Global.dialog_finished.disconnect(_on_dialog_finished)
