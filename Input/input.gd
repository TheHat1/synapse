extends GraphNode

var type: String = "Input"

var input_value = 0.0
var minI = 0.0
var maxI = 10.0

signal value_changed(value: float)

func  _ready() -> void:
	set_slot(0, false, 0, Color.FIREBRICK, true, 1, Color.DARK_CYAN)
	
	name = name.replace("@", "_")

func _on_line_edit_text_submitted(new_text: String) -> void:
	minI = new_text.to_float()
	$VBoxContainer/HBoxContainer2/HSlider.value = 0

func _on_line_edit_2_text_submitted(new_text: String) -> void:
	maxI = new_text.to_float()
	$VBoxContainer/HBoxContainer2/HSlider.value = 0

func _on_h_slider_value_changed(value: float) -> void:
	input_value = $VBoxContainer/HBoxContainer2/HSlider.value * (maxI - minI) / 100
	emit_signal("value_changed",input_value)
	$VBoxContainer/HBoxContainer/Label.text = String.num(input_value,2)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").input_deleted += 1
		queue_free()
