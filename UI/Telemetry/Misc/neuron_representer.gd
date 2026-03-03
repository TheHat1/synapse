extends GraphNode

var intensity:= 0.0
var buffer = 0.0
var current_buffer = 0.0
var activation_treshold = 1.0
var fade_time: float
var elapsed = 0.0

@onready var panel_style = self.get_theme_stylebox("panel")
var base_color:= Color(0.1647, 0.4196, 0.2196)
var active_color:= Color(0.664, 0.933, 0.412, 1.0)

func _ready() -> void:
	set_slot(0, true, 0, Color.DARK_GREEN, true, 0, Color.DARK_GREEN)
	clamp(intensity, 0.0, 100.0)
	clamp(elapsed, 0.0, fade_time)

func _process(delta: float) -> void:
	if current_buffer > buffer:
		current_buffer = remap(elapsed, 0, fade_time, 0, activation_treshold)
		if elapsed > 0.0:
			elapsed -= delta
	else:
		current_buffer = buffer
		elapsed = fade_time
	
	intensity = remap(current_buffer, 0, activation_treshold, 0, 1)
	panel_style.bg_color = base_color.lerp(active_color, intensity)

func _on_fade_time_changed(value: float):
	fade_time = value

func _current_buffer_value(value: float):
	buffer = value

func _pass_activation_treshold(value: float):
	activation_treshold = value
