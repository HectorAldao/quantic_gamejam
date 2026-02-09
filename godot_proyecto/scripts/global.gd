extends Node

signal cantidad_huevos_cambiada(nuevo_valor: int)

var root
var ui
var ui_container
var huevos: int = 0
var huevos_cogidos: int = 0:
	set(value):
		huevos_cogidos = value
		cantidad_huevos_cambiada.emit(huevos_cogidos)

#func _ready() -> void:
#
#	#get_tree().get_node($UI_Layer/HUDContainer/PanelHuevos/Label).text = str(huevos_cogidos)
#
#	root = get_tree().current_scene
#	_search_ui_recursively(root)
#
#
#func _search_ui_recursively(node: Node) -> void:
#	if node.has_signal("interact"):
#		ui = node
#		return
#	for child in node.get_children():
#		_search_ui_recursively(child)
#
#func _process(_delta: float) -> void:
#
#	ui_container = ui.get_children()[0]
#
#
