extends Area2D

var press_times: Array = []
var press_count: int = 0
var time_window: float = 1.0
var required_presses: int = 3
var player_inside: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_inside = false
		press_times.clear()

func _input(_event: InputEvent) -> void:
	if not player_inside:
		return
		
	if Input.is_action_just_pressed("interact"):
		var current_time = Time.get_ticks_msec() / 1000.0
		press_times.append(current_time)
		
		# Remove old presses outside the time window
		press_times = press_times.filter(func(time): return current_time - time < time_window)
		
		# Check if we have 3 presses within 1 second
		if press_times.size() >= required_presses:
			activate_cheat()
			press_times.clear()

func activate_cheat() -> void:
	Global.huevos_cogidos += 100
	print("¡Cheat activado! +100 huevos")
