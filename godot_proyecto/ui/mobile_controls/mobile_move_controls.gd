extends Control

# Configuration variable - can be set to false to manually disable mobile controls
var mobile_controls_enabled: bool = true

# Direction tracking for virtual joystick
var direction_pressed := Vector2.ZERO


func _ready() -> void:
	# Check if running on mobile device
	var is_mobile = _is_mobile_device()
	#is_mobile = true
	
	# Show/hide controls based on mobile detection and enabled setting
	visible = is_mobile and mobile_controls_enabled


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
