extends GraphNode

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")
var type: String = "Neuron"

var edit_menu = load("res://UI/Menus/NeuronEditMenu.tscn")
var isMenuOpen: bool = false

var threshold = 1.0
var discharge_resistor = 0.02
var charge_resistor = 0.02
var buffer = 0.0
var inhib_time = 0.0
var exct_time = 0.0
var V_src = 0.0
var capacitance = 1.0
var discharge_percent = 0.01
var state = "CHARGING"
var elapsed = 0.0
var is_led_on = false
var old_text: String

signal current_buffer_value(value: float)
signal pass_activation_treshold(value: float)

func _ready():
	set_slot(0, true, 0, Color.FIREBRICK, false, 0, Color.BLUE_VIOLET)
	set_slot(1, true, 0, Color.FOREST_GREEN, true, 2, Color.BLUE_VIOLET)
	set_slot(2, true, 1, Color.DARK_CYAN, false, 0, Color.FIREBRICK)
	
	old_text =  $Control/HBoxContainer/Panel2/HBoxContainer/LineEdit.text
	
	name = name.replace("@", "_")

func fire_output(port: int, weight: float):
	get_parent().trigger_from(name, port, weight)

func execute_input(port: int, weight: float):
	match port:
		0:
			on_inhib_in(weight)
		1:
			on_exc_in(weight)
		_:
			print("Unhandled port: ", port)

func on_inhib_in(weight):
	inhib_time = weight

func on_exc_in(weight):
	exct_time = weight

func _process(delta):
	if is_led_on:
		elapsed += delta
		if elapsed >= 0.1:
			is_led_on = false
			$HBoxContainer/Control/Sprite2D.texture = led_off
			elapsed = 0.0
	
	$HBoxContainer4/ProgressBar.value = buffer / threshold * 100
	
	var tau = discharge_resistor * capacitance
	
	if state == "CHARGING":
		if exct_time > 0.0:
			var I_total = (V_src - buffer) / charge_resistor
			buffer += (I_total / capacitance) * exct_time
			exct_time -= delta
			exct_time  = clamp(exct_time, 0.0, 1000.0)
		if inhib_time > 0.0:
			buffer *= exp(-inhib_time / tau)
			inhib_time -= delta
			inhib_time = clamp(inhib_time, 0.0, 1000.0)
		buffer *= exp(-delta / tau)
		
	elif state == "DISCHARGING":
		buffer *= exp(-delta / tau)
		
		if buffer < discharge_percent:
			state = "CHARGING"
	
	if buffer >= threshold:
		state = "DISCHARGING"
		fire_output(0, 0.0)
		$HBoxContainer/Control/Sprite2D.texture = led_on
		is_led_on = true
		$HBoxContainer/Control/AudioStreamPlayer2D.play()
	
	emit_signal("current_buffer_value", buffer)
	emit_signal("pass_activation_treshold", threshold)

func _on_value_changed(value, value2):
	V_src = value
	charge_resistor = value2

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").neuron_deleted += 1
		queue_free()

func _on_line_edit_text_submitted(new_text: String) -> void:
	$Control/HBoxContainer/Panel2/HBoxContainer/LineEdit.keep_editing_on_text_submit = true
	if !new_text.is_valid_float():
		ErrorMessage.show_error("Invalid value")
		$Control/HBoxContainer/Panel2/HBoxContainer/LineEdit.text = old_text
		return
	if new_text.to_float() < 0.0:
		ErrorMessage.show_error("Value must be a positive number")
		$Control/HBoxContainer/Panel2/HBoxContainer/LineEdit.text = old_text
		return
	if new_text.to_float() == 0.0:
		ErrorMessage.show_error("Value can not be 0")
		$Control/HBoxContainer/Panel2/HBoxContainer/LineEdit.text = old_text
		return
	
	discharge_resistor = new_text.to_float()
	old_text = new_text
	$Control/HBoxContainer/Panel2/HBoxContainer/LineEdit.text = str(discharge_resistor)
	$Control/HBoxContainer/Panel2/HBoxContainer/LineEdit.keep_editing_on_text_submit = false

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
	$HBoxContainer/Control/AudioStreamPlayer2D.stream = load(path)
