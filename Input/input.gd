extends GraphNode

var type: String = "Input"

var input_value: = 0.0
var minV: = 0.0
var maxV = 10.0
var is_constant: bool = false

signal v_src_changed(value: float)

func  _ready() -> void:
	set_slot(0, false, 0, Color.FIREBRICK, true, 4, Color.LIGHT_BLUE)
	$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/LineEdit2.text = str(maxV)
	$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.text = str(minV)
	
	name = name.replace("@", "_")
	
	$VBoxContainer/HBoxContainer/VBoxContainer2/CheckButton.button_pressed = is_constant

func _on_line_edit_text_submitted(new_text: String) -> void:
	minV = new_text.to_float()
	$VBoxContainer/HBoxContainer2/HSlider.value = minV

func _on_line_edit_2_text_submitted(new_text: String) -> void:
	maxV = new_text.to_float()
	$VBoxContainer/HBoxContainer2/HSlider.value = 0

func _on_h_slider_value_changed(value: float) -> void:
	input_value = $VBoxContainer/HBoxContainer2/HSlider.value * (maxV - minV) / 100
	emit_signal("v_src_changed", input_value)
	$VBoxContainer/HBoxContainer/Label.text = String.num(input_value,2)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").input_deleted += 1
		get_parent().on_input_delete(name)
		queue_free()

func _on_check_button_toggled(toggled_on: bool) -> void:
	is_constant = toggled_on

func set_value_on_forward_pass(value: float):
	$VBoxContainer/HBoxContainer2/HSlider.value = remap(value, minV, maxV, 0, 100)
