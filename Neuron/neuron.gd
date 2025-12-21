extends GraphNode

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")

var treshold = 1.0
var drain_resistor = -1
var buffer = 0.0
var I_on_inhib = 0.0
var I_on_extc = 0.0
var input = 0.0
var capacitance = 1.0
var decay = 0.0
var drain_resistor_old = -1
var delta_old = 0.0
var capacitance_old = 0.0
var elapsed = 0.0

func _ready():
	set_slot(0, true, 0, Color.FIREBRICK, false, 0, Color.BLUE_VIOLET)
	set_slot(1, true, 0, Color.FOREST_GREEN, true, 0, Color.BLUE_VIOLET)
	set_slot(2, true, 1, Color.DARK_CYAN, false, 0, Color.FIREBRICK)
	clamp(decay, 0.0, 0.999999)

func fire_output(port: int):
	get_parent().trigger_from(name, port)

func execute_input(port: int, weight: float):
	match port:
		0:
			on_inhib_in(weight)
		1:
			on_exc_in(weight)
		_:
			print("Unhandled port: ", port)

func on_inhib_in(weight):
	pass

func on_exc_in(weight):
	pass

func _process(delta):
	$HBoxContainer4/ProgressBar.value = buffer / treshold * 100
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
		buffer += I_total * delta
	else:
		buffer *= decay
		buffer += I_total * (drain_resistor * capacitance) * (1 - decay)
	if buffer >= treshold:
		buffer = 0.0
		fire_output(0)
		$HBoxContainer/Control/Sprite2D.texture = led_on
		$HBoxContainer/Control/AudioStreamPlayer2D.play()
		$HBoxContainer/Control/Sprite2D.texture = led_off
		get_parent().get_parent().get_node("MainMenu").get_node("ScrollContainer").get_node("VBoxContainer").get_node("HBoxContainer5").get_node("Label2").text = str(elapsed)
		elapsed = 0
	elapsed += delta

func _on_value_changed(value):
	input = value

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.double_click:
		get_parent().get_parent().get_node("MainMenu").get_ref(self)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_node("MainMenu").neuron_deleted += 1
		queue_free()
