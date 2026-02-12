@tool
extends Node2D

@export var multiplicador_tamaño: float = 1.0
@export var escala_sprite: float = 2.0
@export var velocidad: float = 50.0
@export var sprite_texture: Texture2D = null
@export var sprite_frames: SpriteFrames = null
@export var cientifica: String = ""
@export var mira_derecha: bool = true

var spawn_area: ReferenceRect = null
var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false
var wait_timer: float = 0.0
var pause_timer: float = 0.0
var is_paused: bool = false
var personaje_in_area: bool = false

# Referencias a los nodos
var area_interaccion: Area2D
var collision_shape_area: CollisionShape2D
var animation_player: AnimationPlayer


func _ready() -> void:
	# Obtener referencias a los nodos
	area_interaccion = $Area2D
	collision_shape_area = $Area2D/CollisionShape2D
	animation_player = $Sprite2D/AnimationPlayer
	
	# Buscar el SpawnArea en el padre y posicionar aleatoriamente
	if get_parent():
		spawn_area = get_parent().get_node_or_null("SpawnArea")
		if spawn_area:
			var spawn_rect = spawn_area.get_rect()
			var spawn_pos = spawn_area.global_position
			global_position = Vector2(
				spawn_pos.x + randf_range(0, spawn_rect.size.x),
				spawn_pos.y + randf_range(0, spawn_rect.size.y)
			)
	
	# Aplicar sprites si están configurados
	if sprite_texture:
		var sprite_node = $Sprite2D
		sprite_node.texture = sprite_texture
		sprite_node.visible = true
		$AnimatedSprite2D.visible = false
	elif sprite_frames:
		var animated_sprite = $AnimatedSprite2D
		animated_sprite.sprite_frames = sprite_frames
		animated_sprite.visible = true
		animated_sprite.play("default")
		$Sprite2D.visible = false
	
	# Aplicar el multiplicador de tamaño
	apply_size_multiplier()
	
	# Verificar visibilidad basada en científica
	_actualizar_visibilidad()
	
	# Conectar señales del área de interacción
	area_interaccion.body_entered.connect(_on_body_entered)
	area_interaccion.body_exited.connect(_on_body_exited)
	
	# Conectar a la señal de interacción global
	Global.interact.connect(_on_interact)
	
	# Conectar a la señal de cambio de científicas aceptadas
	Global.cientificas_aceptadas_changed.connect(_actualizar_visibilidad)
	
	# Elegir primer punto objetivo
	if spawn_area:
		choose_random_target()


func _process(delta: float) -> void:
	# Si está en pausa por el personaje, contar el tiempo
	if is_paused:
		pause_timer -= delta
		if pause_timer <= 0:
			is_paused = false
			# Volver a moverse después de la pausa
			choose_random_target()
		return
	
	# Si está esperando, contar el tiempo
	if wait_timer > 0:
		wait_timer -= delta
		if wait_timer <= 0 and spawn_area:
			choose_random_target()
		return
	
	# Moverse hacia el objetivo
	if is_moving and spawn_area:
		var direction = (target_position - global_position).normalized()
		var distance = global_position.distance_to(target_position)
		
		# Aplicar flip del sprite según la dirección
		if direction.x != 0:  # Solo si hay movimiento horizontal
			var sprite_node = $Sprite2D
			var animated_sprite = $AnimatedSprite2D
			
			if direction.x > 0:  # Movimiento a la derecha
				if sprite_node.visible:
					sprite_node.flip_h = not mira_derecha
				if animated_sprite.visible:
					animated_sprite.flip_h = not mira_derecha
			else:  # Movimiento a la izquierda
				if sprite_node.visible:
					sprite_node.flip_h = mira_derecha
				if animated_sprite.visible:
					animated_sprite.flip_h = mira_derecha
		
		# Si está cerca del objetivo, detenerse
		if distance < 5.0:
			is_moving = false
			# Detener animación de caminar
			var animated_sprite = $AnimatedSprite2D
			if animated_sprite.visible:
				# Si usa AnimatedSprite2D, reproducir animación default
				if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("default"):
					animated_sprite.play("default")
			else:
				# Si usa Sprite2D con AnimationPlayer, detener walk
				if animation_player and animation_player.has_animation("walk"):
					animation_player.stop()
			# Tiempo de espera inversamente proporcional a la velocidad
			# Mayor velocidad = menor tiempo de espera
			wait_timer = randf_range(1.0, 3.0) * (100.0 / max(velocidad, 1.0))
		else:
			# Moverse hacia el objetivo
			global_position += direction * velocidad * delta
			# Reproducir animación de caminar en bucle
			var animated_sprite = $AnimatedSprite2D
			if animated_sprite.visible:
				# Si usa AnimatedSprite2D, reproducir animación walk si existe, sino default
				if animated_sprite.sprite_frames:
					if animated_sprite.sprite_frames.has_animation("walk"):
						if animated_sprite.animation != "walk":
							animated_sprite.play("walk")
					else:
						if animated_sprite.animation != "default":
							animated_sprite.play("default")
			else:
				# Si usa Sprite2D con AnimationPlayer
				if animation_player and animation_player.has_animation("walk"):
					if not animation_player.is_playing() or animation_player.current_animation != "walk":
						animation_player.play("walk")


func apply_size_multiplier() -> void:
	# Aplicar multiplicador al scale del CollisionShape del área
	if collision_shape_area:
		collision_shape_area.scale = Vector2.ONE * multiplicador_tamaño
	
	# Aplicar escala a los sprites
	var sprite_node = $Sprite2D
	var animated_sprite = $AnimatedSprite2D
	
	if sprite_node:
		sprite_node.scale = Vector2.ONE * escala_sprite
	if animated_sprite:
		animated_sprite.scale = Vector2.ONE * escala_sprite


func choose_random_target() -> void:
	if not spawn_area:
		return
	
	# Obtener un punto aleatorio dentro del SpawnArea
	var spawn_rect = spawn_area.get_rect()
	var spawn_pos = spawn_area.global_position
	
	target_position = Vector2(
		spawn_pos.x + randf_range(0, spawn_rect.size.x),
		spawn_pos.y + randf_range(0, spawn_rect.size.y)
	)
	
	is_moving = true


func _on_body_entered(body: Node2D) -> void:
	# Verificar si el cuerpo que entró es el personaje
	if body.name == "Personaje" or body.is_in_group("player"):
		personaje_in_area = true


func _on_body_exited(body: Node2D) -> void:
	# Verificar si el cuerpo que salió es el personaje
	if body.name == "Personaje" or body.is_in_group("player"):
		personaje_in_area = false


func _on_interact() -> void:
	# Solo pausar si el personaje está en el área de interacción
	if personaje_in_area and not is_paused:
		is_paused = true
		pause_timer = 2.0
		is_moving = false
		# Detener animación al interactuar
		var animated_sprite = $AnimatedSprite2D
		if animated_sprite.visible:
			# Si usa AnimatedSprite2D, reproducir animación default
			if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("default"):
				animated_sprite.play("default")
		else:
			# Si usa Sprite2D con AnimationPlayer, detener walk
			if animation_player and animation_player.has_animation("walk"):
				animation_player.stop()

		$Corazones/AnimationPlayer.play("hearts")


func _actualizar_visibilidad() -> void:
	# Si no se ha especificado científica, el animal es visible por defecto
	if cientifica == "":
		visible = true
		return
	
	# Verificar si la científica está en la lista de aceptadas
	visible = Global.cientificas_aceptadas.has(cientifica)
