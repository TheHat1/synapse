extends GraphNode

var resistance = 0.02
var V_src = 0.0
var type = "Resistor"
var old_text: String

signal value_changed_resistor(v_src: float, resistance: float)

func  _ready() -> void:
	set_slot(0, true, 4, Color.LIGHT_BLUE, true, 1, Color.DARK_CYAN)
	
	old_text = $HBoxContainer/LineEdit.text
	
	name = name.replace("@", "_")

func _on_line_edit_text_submitted(new_text: String) -> void:
	$HBoxContainer/LineEdit.keep_editing_on_text_submit = true
	if !new_text.is_valid_float():
		ErrorMessage.show_error("Invalid value")
		$HBoxContainer/LineEdit.text = old_text
		return
	if new_text.to_float() < 0.0:
		ErrorMessage.show_error("Value must be a positive number")
		$HBoxContainer/LineEdit.text = old_text
		return
	if new_text.to_float() == 0.0:
		ErrorMessage.show_error("Value can not be 0")
		$HBoxContainer/LineEdit.text = old_text
		return
	
	resistance = new_text.to_float()
	old_text = new_text
	$HBoxContainer/LineEdit.text = str(resistance)
	$HBoxContainer/LineEdit.keep_editing_on_text_submit = false
	emit_signal("value_changed_resistor", V_src, resistance)

func _on_v_src_changed(value):
	V_src = value
	emit_signal("value_changed_resistor", V_src, resistance)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").weight_deleted += 1
		queue_free()
