extends CanvasLayer

# Configuration variable - can be set to false to manually disable mobile controls
var mobile_controls_enabled: bool = true

# Direction tracking for virtual joystick
var direction_pressed := Vector2.ZERO
var interact_pressed := false


func _ready() -> void:
	# Check if running on mobile device
	var is_mobile = _is_mobile_device()
	
	# Show/hide controls based on mobile detection and enabled setting
	visible = is_mobile and mobile_controls_enabled
	
	# Connect button signals (TouchScreenButton uses 'pressed' and 'released')
	$DirectionButtons/UpButton.pressed.connect(_on_up_pressed)
	$DirectionButtons/DownButton.pressed.connect(_on_down_pressed)
	$DirectionButtons/LeftButton.pressed.connect(_on_left_pressed)
	$DirectionButtons/RightButton.pressed.connect(_on_right_pressed)
	
	$DirectionButtons/UpButton.released.connect(_on_up_released)
	$DirectionButtons/DownButton.released.connect(_on_down_released)
	$DirectionButtons/LeftButton.released.connect(_on_left_released)
	$DirectionButtons/RightButton.released.connect(_on_right_released)
	
	$InteractButton.pressed.connect(_on_interact_pressed)
	$InteractButton.released.connect(_on_interact_released)


func _is_mobile_device() -> bool:
	# For HTML5 export, check if the browser is on a mobile device
	# using JavaScript evaluation
	if OS.has_feature("web"):
		# Check for touch support and mobile user agent patterns
		var user_agent = JavaScriptBridge.eval("""
			navigator.userAgent || navigator.vendor || window.opera
		""", true)
		
		if user_agent:
			var ua_str = str(user_agent).to_lower()
			# Check for common mobile indicators
			if "mobile" in ua_str or "android" in ua_str or "iphone" in ua_str or "ipad" in ua_str or "ipod" in ua_str:
				return true
		
		# Also check for touch support
		var has_touch = JavaScriptBridge.eval("""
			('ontouchstart' in window) || (navigator.maxTouchPoints > 0)
		""", true)
		
		return bool(has_touch)
	
	# For non-web exports (shouldn't happen, but as fallback)
	return OS.get_name() in ["Android", "iOS"]


func set_controls_enabled(enabled: bool) -> void:
	"""Allow external scripts to enable/disable mobile controls"""
	mobile_controls_enabled = enabled
	
	# Only show if mobile AND enabled
	if _is_mobile_device():
		visible = enabled
	else:
		visible = false


# Direction button handlers
func _on_up_pressed() -> void:
	direction_pressed.y = -1


func _on_up_released() -> void:
	direction_pressed.y = 0


func _on_down_pressed() -> void:
	direction_pressed.y = 1


func _on_down_released() -> void:
	direction_pressed.y = 0


func _on_left_pressed() -> void:
	direction_pressed.x = -1


func _on_left_released() -> void:
	direction_pressed.x = 0


func _on_right_pressed() -> void:
	direction_pressed.x = 1


func _on_right_released() -> void:
	direction_pressed.x = 0


# Interact button handlers
func _on_interact_pressed() -> void:
	interact_pressed = true


func _on_interact_released() -> void:
	interact_pressed = false


func get_direction() -> Vector2:
	"""Get the current direction from mobile controls"""
	return direction_pressed.normalized()


func is_interact_pressed() -> bool:
	"""Check if interact button is pressed"""
	return interact_pressed
