extends Node2D

@onready var candado: Node2D = $Candado

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	candado.visible = Global.candado_cerrado
	Global.not_enough_eggs.connect(_mover_candado)
	Global.open_final_door.connect(_abrir_candado)

func _mover_candado() -> void:
	var ap: AnimationPlayer = candado.get_node("AnimationPlayer")
	ap.play("no")

func _abrir_candado() -> void:
	var ap: AnimationPlayer = candado.get_node("AnimationPlayer")
	ap.play("open")
	await ap.animation_finished
	candado.visible = false
	Global.final_door_opend.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
