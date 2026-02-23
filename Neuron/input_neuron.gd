extends GraphNode

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")
var type: String = "InputNeuron"

var input: float
var elapsed = 0.0
var is_led_on = false
var threshold = 1.0
var buffer = 0.0
var capacitance = 1.0
var delta_old = 0.0
var capacitance_old = 0.0
var drain_resistor_old = -1
var drain_resistor = -1
var decay = 0.0

func _ready():
	set_slot(0, false, 0, Color.FIREBRICK, false, 0, Color.BLUE_VIOLET)
	set_slot(1, true, 1, Color.DARK_CYAN, true, 2, Color.BLUE_VIOLET)
	
	name = name.replace("@", "_")

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").neuron_deleted += 1
		queue_free()

func _on_value_changed(value):
	input = value

func fire_output(port: int, weight: float):
	get_parent().trigger_from(name, port, weight)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.double_click:
		get_parent().get_parent().get_parent().get_node("MainMenu").get_ref(self)

func _process(delta):
	if is_led_on:
		elapsed += delta
		if elapsed >= 0.1:
			is_led_on = false
			$HBoxContainer4/Control/Sprite2D.texture = led_off
			elapsed = 0.0
	
	$HBoxContainer6/ProgressBar.value = buffer / threshold * 100
	
	if buffer < 0:
		buffer = 0.0
		
	var I_total = input / capacitance 
	
	if drain_resistor != drain_resistor_old:
		decay = exp(-delta/(drain_resistor * capacitance))
		drain_resistor_old = drain_resistor
	
	if delta != delta_old and drain_resistor > 0:
		decay = exp(-delta/(drain_resistor * capacitance))
		delta_old = delta
	
	if capacitance != capacitance_old:
		decay = exp(-delta/(drain_resistor * capacitance))
		capacitance_old = capacitance
	
	if drain_resistor <= 0:
		buffer += (I_total) * delta
	else:
		buffer *= decay
		buffer += (I_total) * (drain_resistor * capacitance) * (1 - decay)
	
	if buffer >= threshold:
		buffer -= threshold
		fire_output(0, 0.0)
		$HBoxContainer4/Control/Sprite2D.texture = led_on
		is_led_on = true
		$HBoxContainer4/Control/AudioStreamPlayer2D.play()
