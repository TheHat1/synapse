extends Control

var ref: GraphNode

func _ready() -> void:
	$Panel/MarginContainer/VBoxContainer/Title/HBoxContainer/LineEditTitle.text = ref.title
	$Panel/MarginContainer/VBoxContainer/Capacitance/HBoxContainer/LineEditCap.text = str(ref.capacitance)
	$Panel/MarginContainer/VBoxContainer/Threshold/HBoxContainer/LineEditThreshold.text = str(ref.threshold)
	$Panel/MarginContainer/VBoxContainer/Vsrc/HBoxContainer/Label2.text = str(ref.V_src)
	$Panel/MarginContainer/VBoxContainer/DischargeR/HBoxContainer/Label2.text = str(ref.discharge_resistor)
	$Panel/MarginContainer/VBoxContainer/ChargeR/HBoxContainer/Label2.text = str(ref.charge_resistor)


func _on_line_edit_title_text_submitted(new_text: String) -> void:
	if ref != null and !new_text.strip_edges().is_empty():
		ref.title = new_text.strip_edges()
		$Panel/MarginContainer/VBoxContainer/Title/HBoxContainer/LineEditTitle.text = ref.title
	else:
		$Panel/MarginContainer/VBoxContainer/Title/HBoxContainer/LineEditTitle.text = ""


func _on_line_edit_cap_text_submitted(new_text: String) -> void:
	if ref != null and new_text.to_float() > 0:
		ref.capacitance = new_text.to_float()
		$Panel/MarginContainer/VBoxContainer/Capacitance/HBoxContainer/LineEditCap.text = str(ref.capacitance)

func _on_line_edit_threshold_text_submitted(new_text: String) -> void:
	if ref != null and new_text.to_float() > 0:
		ref.threshold = new_text.to_float()
		$Panel/MarginContainer/VBoxContainer/Threshold/HBoxContainer/LineEditThreshold.text = str(ref.threshold)
