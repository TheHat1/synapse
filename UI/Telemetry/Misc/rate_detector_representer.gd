extends GraphNode

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")

var current_activation: float
var is_activated: bool

func _ready() -> void:
	set_slot(0, true, 0, Color.DARK_GRAY, false, 0, Color.DARK_GREEN)

func _current_rate(value: float, value2: bool):
	current_activation = value
	is_activated = value2

func _process(_delta: float) -> void:
	$Control/HBoxContainer/Label.text = str(current_activation) + " Hz"
	if is_activated:
		$Control/HBoxContainer/Sprite2D.texture = led_on
	else:
		$Control/HBoxContainer/Sprite2D.texture = led_off
