extends GraphNode

var type = "BoostConverter"
var old_text: String = "1.0"
var gain: float = 1.0
var enabled: bool = false
var vcc: float = 0.0
var charge_resistor: float

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")

signal value_changed_resistor(v_src: float, resistance: float)

func _ready() -> void:
	set_slot(0, true, 1, Color.DARK_CYAN, false, 0, Color.GOLDENROD)
	set_slot(1, false, 1, Color.DARK_CYAN, true, 1, Color.DARK_CYAN)
	set_slot(2, true, 3, Color.DIM_GRAY, false, 0, Color.GOLDENROD)

func _on_line_edit_text_submitted(new_text: String) -> void:
	$Control2/LineEdit.keep_editing_on_text_submit = true
	if !new_text.is_valid_float():
		ErrorMessage.show_error("Invalid value")
		$Control2/LineEdit.text = old_text
		return
	if new_text.to_float() < 0.0:
		ErrorMessage.show_error("Value must be a positive number")
		$Control2/LineEdit.text = old_text
		return
	if new_text.to_float() == 0.0:
		ErrorMessage.show_error("Value can not be 0")
		$Control2/LineEdit.text = old_text
		return
	
	gain = new_text.to_float()
	old_text = new_text
	$Control2/LineEdit.text = str(gain)
	$Control2/LineEdit.keep_editing_on_text_submit = false

func _on_value_changed(value, value2):
	vcc = value
	charge_resistor = value2
	if enabled:
		emit_signal("value_changed_resistor", value + gain, value2)
	else:
		emit_signal("value_changed_resistor", value, value2)

func _on_gate_status_change(status: bool):
	enabled = status
	if status:
		$Control2/Control/Sprite2D.texture = led_on
		emit_signal("value_changed_resistor", vcc + gain, charge_resistor)
	else :
		$Control2/Control/Sprite2D.texture = led_off
		emit_signal("value_changed_resistor", vcc , charge_resistor)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").boosters_deleted += 1
		queue_free()
