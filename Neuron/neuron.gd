extends GraphNode

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")

var treshold = 1.0
var drain_resistor = 1e3
var buffer = 0.0
var drain_on_inhib = 1.0
var add_on_extc = 1.0
var input = 0.0
var deltaT = 0.0
var capacitance = 1.0
var decay = 0.0

func _ready():
	set_slot(0, true, 2, Color.DARK_GOLDENROD, true, 2, Color.DARK_GOLDENROD)
	set_slot(1, true, 0, Color.FIREBRICK, true, 0, Color.BLUE_VIOLET)
	set_slot(2, true, 0, Color.FOREST_GREEN, false, 0, Color.FIREBRICK)
	set_slot(3, true, 1, Color.DARK_CYAN, false, 0, Color.FIREBRICK)

func fire_output(port: int):
	get_parent().trigger_from(name, port)

func execute_input(port: int):
	match port:
		0:
			on_inpulse_in()
		1:
			on_inhib_in()
		2:
			on_exc_in()
		_:
			print("Unhandled port: ", port)

func on_inpulse_in():
	fire_output(0)
	buffer *= decay
	buffer += (input / capacitance) * (drain_resistor * capacitance) * (1 - decay)
	if buffer >= treshold:
		buffer = 0.0
		print(elapsed)
		elapsed = 0.0
		fire_output(1)
		$HBoxContainer/Control/Sprite2D.texture = led_on
		$HBoxContainer/Control/AudioStreamPlayer2D.play()
		await $HBoxContainer/Control/AudioStreamPlayer2D.finished
		$HBoxContainer/Control/Sprite2D.texture = led_off

func on_inhib_in():
	if buffer > drain_on_inhib:
		buffer -= drain_on_inhib
	else :
		buffer = 0.0

func on_exc_in():
	buffer += add_on_extc
	if buffer >= treshold:
		buffer = 0.0
		fire_output(1)
		$HBoxContainer/Control/Sprite2D.texture = led_on
		$HBoxContainer/Control/AudioStreamPlayer2D.play()
		await $HBoxContainer/Control/AudioStreamPlayer2D.finished
		$HBoxContainer/Control/Sprite2D.texture = led_off
var elapsed = 0.0
func _process(delta) -> void:
	$HBoxContainer4/ProgressBar.value = buffer / treshold * 100
	elapsed += delta

func _on_value_changed(value):
	input = value

func _on_deltaT_changed(value):
		decay = exp(-value/(drain_resistor * capacitance))
