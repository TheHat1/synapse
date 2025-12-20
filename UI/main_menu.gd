extends Panel

var neuron_count = 1
var pacemaker_count = 1
var input_count = 1
var ref = null

func _process(_delta) -> void:
	$ScrollContainer/VBoxContainer/HBoxContainer/Label2.text = str(neuron_count - 1)
	$ScrollContainer/VBoxContainer/HBoxContainer2/Label2.text = str(pacemaker_count - 1)
	$ScrollContainer/VBoxContainer/HBoxContainer3/Label2.text = str(input_count - 1)

func _on_h_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)

func _on_button_pressed() -> void:
	get_tree().quit()

func get_ref(r):
	ref = r
	$ScrollContainer/VBoxContainer/HBoxContainer4/Label.text = r.title

func _on_line_edit_text_submitted(new_text: String) -> void:
	if ref != null and new_text.to_float() > 0:
		ref.capacitance = new_text.to_float()
