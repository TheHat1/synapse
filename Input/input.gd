extends GraphNode

var type: String = "Input"

var input_value: = 0.0
var minV: = 0.0
var maxV = 10.0
var is_constant: bool = false
var old_text_min: String
var old_text_max: String

signal v_src_changed(value: float)

func  _ready() -> void:
	set_slot(0, false, 0, Color.FIREBRICK, true, 4, Color.LIGHT_BLUE)
	$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/LineEdit2.text = str(maxV)
	$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.text = str(minV)
	
	old_text_min = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.text
	old_text_max = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/LineEdit2.text
	
	name = name.replace("@", "_")
	
	$VBoxContainer/HBoxContainer/VBoxContainer2/CheckButton.button_pressed = is_constant

func _on_line_edit_text_submitted(new_text: String) -> void:
	$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.keep_editing_on_text_submit = true
	if !new_text.is_valid_float():
		ErrorMessage.show_error("Invalid value")
		$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.text = old_text_min
		return
	if new_text.to_float() < 0.0:
		ErrorMessage.show_error("Value must be a positive number")
		$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.text = old_text_min
		return
	
	minV = new_text.to_float()
	$VBoxContainer/HBoxContainer2/HSlider.value = minV
	old_text_min = new_text
	$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.text = str(minV)
	$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.keep_editing_on_text_submit = false

func _on_line_edit_2_text_submitted(new_text: String) -> void:
	$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit2.keep_editing_on_text_submit = true
	if !new_text.is_valid_float():
		ErrorMessage.show_error("Invalid value")
		$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit2.text = old_text_min
		return
	if new_text.to_float() < 0.0:
		ErrorMessage.show_error("Value must be a positive number")
		$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit2.text = old_text_min
		return
	
	maxV = new_text.to_float()
	$VBoxContainer/HBoxContainer2/HSlider.value = 0
	old_text_max = new_text
	$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit2.text = str(maxV)
	$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit2.keep_editing_on_text_submit = false

func _on_h_slider_value_changed(value: float) -> void:
	input_value = $VBoxContainer/HBoxContainer2/HSlider.value * (maxV - minV) / 100
	emit_signal("v_src_changed", input_value)
	$VBoxContainer/HBoxContainer/Label.text = String.num(input_value,2)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").inputs_deleted += 1
		get_parent().on_input_delete(name)
		queue_free()

func _on_check_button_toggled(toggled_on: bool) -> void:
	is_constant = toggled_on

func set_value_on_forward_pass(value: float):
	$VBoxContainer/HBoxContainer2/HSlider.value = remap(value, minV, maxV, 0, 100)
