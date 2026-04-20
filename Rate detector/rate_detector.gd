extends GraphNode

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")
var type: String = "RateDetector"

var rate = 0.0
var target_hz = 1.0
var output_on = false
var old_text: String
var post_synaptic_neuron: StringName

signal current_rate(value: float, value2: bool)

func _ready():
	set_slot(0, true, 2, Color.BLUE_VIOLET, false, 0, Color.GOLDENROD)
	
	old_text = $HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.text
	
	name = name.replace("@", "_")

func execute_input(port: int, _weight: float):
	if port == 0:
		rate += 1.0

func _process(delta):
	rate -= rate * delta
	rate = max(rate, 0.0)
	output_on = rate >= target_hz
	if output_on:
		$HBoxContainer/Control/Sprite2D.texture = led_on
	else :
		$HBoxContainer/Control/Sprite2D.texture = led_off
	emit_signal("current_rate", snappedf(rate, 0.01), output_on)

func _on_line_edit_text_submitted(new_text: String) -> void:
	$HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.keep_editing_on_text_submit = true
	if !new_text.is_valid_float():
		ErrorMessage.show_error("Invalid value")
		$HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.text = old_text
		return
	if new_text.to_float() < 0.0:
		ErrorMessage.show_error("Value must be a positive number")
		$HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.text = old_text
		return
	if new_text.to_float() == 0.0:
		ErrorMessage.show_error("Value can not be 0")
		$HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.text = old_text
		return
	
	target_hz = new_text.to_float()
	old_text = new_text
	$HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.keep_editing_on_text_submit = false

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").rate_detectors_deleted += 1
		get_parent().on_rate_detector_delete(name)
		queue_free()
