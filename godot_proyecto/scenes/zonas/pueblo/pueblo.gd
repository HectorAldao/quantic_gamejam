extends Node2D

signal dialog_requested(npc_name: String, dialog_lines: Array)

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
		var dialog_lines = dialogs.get("heisenberg_tutorial", [])
		dialog_requested.emit("heisenberg", dialog_lines)
