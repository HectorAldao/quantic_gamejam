extends Node2D

@export var min_time: float = 5.0
@export var max_time: float = 15.0

var label: Label
var timer: Timer
var count: int = 0

func _ready() -> void:
	# Get the label node
	label = $HuevosLabel
	
	# Create and configure timer
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
	# Initialize label
	label.text = str(count)
	
	# Start the timer
	_start_random_timer()

func _start_random_timer() -> void:
	var random_time = randf_range(min_time, max_time)
	timer.start(random_time)

func _on_timer_timeout() -> void:
	count += 1
	label.text = str(count)
	_start_random_timer()

func _process(delta: float) -> void:
	pass
