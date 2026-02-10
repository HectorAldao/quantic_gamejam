extends CharacterBody2D

const SPEED = 300.0


var animated_sprite
var mobile_move_controls = null
var mobile_interact_controls = null
var can_move: bool = true


func _ready() -> void:
	animated_sprite = $AnimatedSprite2D
	
	animated_sprite.play("idle")
	
	# Get reference to mobile controls if they exist
	mobile_move_controls = get_node_or_null("Camera2D/MobileMoveControls")
	mobile_interact_controls = get_node_or_null("Camera2D/MobileInteractControls")
	
	# Connect to Global change_move signal
	Global.change_move.connect(_on_change_move)


func _physics_process(_delta: float) -> void:
	
	if not can_move:
		return
	
	# Get input direction for top-down movement
	var direction = Input.get_vector("move_character_left", "move_character_right", "move_character_up", "move_character_down")
	
	# If mobile move controls exist and are visible, use their input instead
	if mobile_move_controls and mobile_move_controls.visible:
		var mobile_dir = mobile_move_controls.get_direction()
		if mobile_dir != Vector2.ZERO:
			direction = mobile_dir
	
	# Apply movement
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		
		# Play animation based on direction
		if abs(direction.x) > abs(direction.y):
			# Horizontal movement is dominant
			if direction.x > 0:
				animated_sprite.play("right")
			else:
				animated_sprite.play("left")
		else:
			# Vertical movement is dominant
			if direction.y > 0:
				animated_sprite.play("down")
			else:
				animated_sprite.play("up")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		animated_sprite.play("idle")
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	# Handle interact button
	if event.is_action_pressed("interact"):
		Global.interact.emit()
		print("E pulsada")
	
	# Handle quit button
	if event.is_action_pressed("quit"):
		Global.quit.emit()
	
	# Also check mobile interact controls for interact button
	if mobile_interact_controls and mobile_interact_controls.visible:
		if mobile_interact_controls.is_interact_pressed():
			Global.interact.emit()
			# Reset the pressed state to prevent multiple triggers
			mobile_interact_controls.interact_pressed = false

func _on_change_move(tf: bool) -> void:
	if tf:
		can_move = true
	else:
		can_move = false
