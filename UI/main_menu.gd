extends Panel

var neuron_count = 1
var input_count = 1
var neuron_deleted = 1
var input_deleted = 1

var ref = null
var ref_title: String
var ref_capacitance: String
var ref_threshold: String
var ref_drain: String
var ref_input: String

func _process(_delta) -> void:
	$VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/Label2.text = str(neuron_count - neuron_deleted)
	$VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer3/Label2.text = str(input_count - input_deleted)

func _on_h_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)

func _on_button_pressed() -> void:
	get_tree().quit()

func get_ref(r):
	ref = r
	$VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer4/Label.text = r.title
	$VBoxContainer/ScrollContainer/VBoxContainer/Title/HBoxContainer/LineEdit.text = ""
	ref_title = r.title
	$VBoxContainer/ScrollContainer/VBoxContainer/Capacitance/HBoxContainer/LineEdit.text = str(r.capacitance)
	ref_capacitance = str(r.capacitance)
	$VBoxContainer/ScrollContainer/VBoxContainer/Threshold/HBoxContainer/LineEdit.text = str(r.threshold)
	ref_threshold = str(r.threshold)
	$VBoxContainer/ScrollContainer/VBoxContainer/Drain/HBoxContainer/LineEdit.text = str(r.drain_resistor)
	ref_drain = str(r.drain_resistor)
	$VBoxContainer/ScrollContainer/VBoxContainer/Input/HBoxContainer/LineEdit.text = str(r.input)
	ref_input = str(r.input)

func _on_line_edit_text_submitted(new_text: String) -> void:
	if ref != null and new_text.to_float() > 0:
		ref.capacitance = new_text.to_float()
		$VBoxContainer/ScrollContainer/VBoxContainer/Capacitance/HBoxContainer/LineEdit.text = str(ref.capacitance)

func _on_line_edit_text_submitted_treshold(new_text: String) -> void:
	if ref != null and new_text.to_float() > 0:
		ref.threshold = new_text.to_float()
		$VBoxContainer/ScrollContainer/VBoxContainer/Threshold/HBoxContainer/LineEdit.text = str(ref.threshold)

func _on_line_edit_text_submitted_drain(new_text: String) -> void:
	if ref != null:
		ref.drain_resistor = new_text.to_float()
		$VBoxContainer/ScrollContainer/VBoxContainer/Drain/HBoxContainer/LineEdit.text = str(ref.drain_resistor)

func _on_line_edit_text_submitted_input(new_text: String) -> void:
	if ref != null and new_text.to_float() > 0:
		ref.input = new_text.to_float()
		$VBoxContainer/ScrollContainer/VBoxContainer/Input/HBoxContainer/LineEdit.text = str(ref.input)

func _on_line_edit_text_submitted_title(new_text: String) -> void:
	if ref != null and !new_text.strip_edges().is_empty():
		ref.title = new_text.strip_edges()
		$VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer4/Label.text = ref.title
	else:
		$VBoxContainer/ScrollContainer/VBoxContainer/Title/HBoxContainer/LineEdit.text = ""
