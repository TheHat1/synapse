extends GraphNode

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")
var temp = 100

func _ready():
	set_slot(0, true, 0, Color.DARK_GOLDENROD, true, 0, Color.DARK_GOLDENROD)
	set_slot(1, true, 0, Color.FIREBRICK, true, 0, Color.BLUE_VIOLET)
	set_slot(2, true, 0, Color.FOREST_GREEN, false, 0, Color.FIREBRICK)

func fire_output(port: int):
	get_parent().trigger_from(name, port)

func execute_input(port: int):
	match port:
		0:
			on_inpulse_in()
			self.position
		1:
			on_inhib_in()
		2:
			on_exc_in()
		_:
			print("Unhandled port: ", port)

func _process(_delta):
	temp += 1
	if(temp == 101):
		fire_output(1)
		temp = 0

func on_inpulse_in():
	fire_output(0)
	$HBoxContainer/Control/Sprite2D.texture = led_on
	$HBoxContainer/Control/AudioStreamPlayer2D.play()
	await $HBoxContainer/Control/AudioStreamPlayer2D.finished
	$HBoxContainer/Control/Sprite2D.texture = led_off

func on_inhib_in():
	pass

func on_exc_in():
	pass
