extends GraphNode

var intensity:= 0.0
var fade_time = 0.5

@onready var panel_style = self.get_theme_stylebox("panel")
var base_color:= Color(0.1647, 0.4196, 0.2196)
var active_color:= Color(0.664, 0.933, 0.412, 1.0)

func _ready() -> void:
	set_slot(0, true, 0, Color.DARK_GREEN, true, 0, Color.DARK_GREEN)
	clamp(intensity, 0.0, 1.0)
	clamp(fade_time, 0.005, 1)

func _on_fade_time_changed(value: float):
	fade_time = value

func _on_spike():
	intensity = 1

func _process(delta: float) -> void:
	if intensity > 0.0:
		intensity -= delta / fade_time 
	
	panel_style.bg_color = base_color.lerp(active_color, intensity)
