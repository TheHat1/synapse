extends GraphNode

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")
var type: String = "InputNeuron"

var edit_menu = load("res://UI/Menus/NeuronEditMenu.tscn")
var isMenuOpen: bool = false

var threshold = 1.0
var discharge_resistor = 0.02
var charge_resistor = 0.02
var buffer = 0.0
var V_src = 0.0
var capacitance = 1.0
var discharge_percent = 0.01
var state = "CHARGING"
var elapsed = 0.0
var is_led_on = false

signal current_buffer_value(value: float)
signal pass_activation_treshold(value: float)

func _ready():
	set_slot(0, false, 0, Color.FIREBRICK, false, 0, Color.BLUE_VIOLET)
	set_slot(1, true, 1, Color.DARK_CYAN, true, 2, Color.BLUE_VIOLET)
	
	name = name.replace("@", "_")

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").neuron_deleted += 1
		queue_free()

func _on_value_changed(value, value2):
	V_src = value
	charge_resistor = value2

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
	
	var tau = discharge_resistor * capacitance
	
	if state == "CHARGING":
		var I_total = (V_src - buffer) / charge_resistor
		buffer += (I_total / capacitance) * delta
		
		buffer *= exp(-delta / tau)
		
	elif state == "DISCHARGING":
		buffer *= exp(-delta / tau)
		
		if buffer < discharge_percent:
			state = "CHARGING"
	
	if buffer >= threshold:
		state = "DISCHARGING"
		fire_output(0, 0.0)
		$HBoxContainer4/Control/Sprite2D.texture = led_on
		is_led_on = true
		$HBoxContainer4/Control/AudioStreamPlayer2D.play()
	
	emit_signal("current_buffer_value", buffer)
	emit_signal("pass_activation_treshold", threshold)

func _on_line_edit_text_submitted(new_text: String) -> void:
	discharge_resistor = new_text.to_float()

func _on_texture_button_pressed() -> void:
	if !isMenuOpen:
		edit_menu = load("res://UI/Menus/NeuronEditMenu.tscn").instantiate()
		edit_menu.ref = self
		add_child(edit_menu)
		isMenuOpen = true
	else:
		edit_menu.queue_free()
		isMenuOpen = false

func change_sound(path: String):
	$HBoxContainer4/Control/AudioStreamPlayer2D.stream = load(path)
