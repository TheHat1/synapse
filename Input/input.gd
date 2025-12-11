extends GraphNode

var input_value = 1.0
var minR = 1.0
var maxR = 10.0

var elapsed := 0.0

signal value_changed(value: float)

func  _ready() -> void:
	set_slot(0, false, 0, Color.FIREBRICK, true, 1, Color.DARK_CYAN)
	randomize()

func _process(delta) -> void:
	elapsed += delta
	if elapsed >= (4 / $VBoxContainer/HBoxContainer2/HSlider.value ):
		elapsed -= 4 / $VBoxContainer/HBoxContainer2/HSlider.value
		var random = randf_range(minR, maxR)
		if input_value != random:
			input_value = random
			emit_signal("value_changed",input_value)
			$VBoxContainer/HBoxContainer/Label.text = String.num(input_value,2)

func _on_line_edit_text_submitted(new_text: String) -> void:
	minR = new_text.to_float()

func _on_line_edit_2_text_submitted(new_text: String) -> void:
	maxR = new_text.to_float()
