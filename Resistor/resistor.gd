extends GraphNode

var resistance = 0.02
var V_src = 0.0
var type = "Resistor"

signal value_changed_resistor(v_src: float, resistance: float)

func  _ready() -> void:
	set_slot(0, true, 4, Color.LIGHT_BLUE, true, 1, Color.DARK_CYAN)
	
	name = name.replace("@", "_")

func _on_line_edit_text_submitted(new_text: String) -> void:
	resistance = new_text.to_float()
	emit_signal("value_changed_resistor", V_src, resistance)

func _on_v_src_changed(value):
	V_src = value
	emit_signal("value_changed_resistor", V_src, resistance)
