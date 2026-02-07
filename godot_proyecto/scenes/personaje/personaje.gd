extends CharacterBody2D

signal interact

const SPEED = 300.0


var animated_sprite


func _ready() -> void:
	animated_sprite = $AnimatedSprite2D
	
	animated_sprite.play("idle")


func _physics_process(_delta: float) -> void:
	# Get input direction for top-down movement
	var direction = Input.get_vector("move_character_left", "move_character_right", "move_character_up", "move_character_down")
	
	
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
		interact.emit()
