extends Node2D

@export var min_time: float = 5.0
@export var max_time: float = 15.0
@export var max_huevos: int = 10

var label: Label
var timer: Timer
var count: int = 0
var base_min_time: float
var base_max_time: float
var base_max_huevos: int

func _ready() -> void:
	# Store base times
	base_min_time = min_time
	base_max_time = max_time
	base_max_huevos = max_huevos
	
	# Get the label node
	label = $HuevosLabel
	
	# Connect to global signal
	Global.cientificas_aceptadas_changed.connect(_on_cientificas_aceptadas_changed)
	
	# Create and configure timer
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
	# Apply initial cientificas bonus
	_on_cientificas_aceptadas_changed()
	
	# Initialize label
	label.text = str(count)
	
	# Start the timer
	_start_random_timer()
	
	$AnimationPlayer.play("float")

func _start_random_timer() -> void:
	var random_time = randf_range(min_time, max_time)
	timer.start(random_time)

func _on_timer_timeout() -> void:
	if count < max_huevos:
		count += 1
		label.text = str(count)
	_start_random_timer()

func _on_cientificas_aceptadas_changed() -> void:
	# Reset to base times
	min_time = base_min_time
	max_time = base_max_time
	
	# Apply bonuses based on accepted cientificas
	if Global.cientificas_aceptadas.has("curie"):
		min_time -= 1
		max_time -= 1
		max_huevos += 2
	
	if Global.cientificas_aceptadas.has("dirac"):
		min_time -= 1
		max_time -= 2
		max_huevos += 2
	
	if Global.cientificas_aceptadas.has("bohr"):
		min_time -= 1
		max_time -= 3
		max_huevos += 3
	
	if Global.cientificas_aceptadas.has("schrodinger"):
		min_time -= 1
		max_time -= 4
		max_huevos += 3
	
	# Ensure times don't go below a minimum threshold
	min_time = max(min_time, 0.5)
	max_time = max(max_time, 1.0)

func _process(_delta: float) -> void:
	pass
