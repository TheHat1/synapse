extends GraphNode

var isToggled = false
var interval := 1.0
var elapsed := 0.0
var frequency_hz := 1.0

signal deltaT_changed(value: float)

func _ready() -> void:
	set_slot(0, false, 0, Color.FIREBRICK, true, 2, Color.DARK_GOLDENROD)

func fire_output(port: int):
	get_parent().trigger_from(name, port)

func _on_check_button_toggled(toggled_on: bool) -> void:
	isToggled = toggled_on

func _process(delta: float) -> void:
	if isToggled:
		elapsed += delta
		if elapsed >= interval:
			elapsed -= interval
			fire_output(0)

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.to_float() > 0:
		frequency_hz = new_text.to_float()
		interval = 1.0 / frequency_hz
		emit_signal("deltaT_changed",interval)
	else:
		$HBoxContainer/LineEdit.text = str(frequency_hz)
