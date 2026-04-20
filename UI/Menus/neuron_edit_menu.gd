extends Control

var ref: GraphNode
var old_text_title: String
var old_text_cap: String
var old_text_thr: String
var old_text_dsg: String

func _ready() -> void:
	$Panel/MarginContainer/VBoxContainer/Title/HBoxContainer/LineEditTitle.text = ref.title
	old_text_title = ref.title
	$Panel/MarginContainer/VBoxContainer/Capacitance/HBoxContainer/LineEditCap.text = str(ref.capacitance)
	old_text_cap = str(ref.capacitance)
	$Panel/MarginContainer/VBoxContainer/Threshold/HBoxContainer/LineEditThreshold.text = str(ref.threshold)
	old_text_thr = str(ref.threshold)
	$Panel/MarginContainer/VBoxContainer/DischargePrstg/HBoxContainer/LineEditDischargePrstg.text = str(ref.discharge_percent)
	old_text_dsg = str(ref.discharge_percent)
	$Panel/MarginContainer/VBoxContainer/Vsrc/HBoxContainer/Label2.text = str(ref.V_src)
	$Panel/MarginContainer/VBoxContainer/DischargeR/HBoxContainer/Label2.text = str(ref.discharge_resistor)
	$Panel/MarginContainer/VBoxContainer/ChargeR/HBoxContainer/Label2.text = str(ref.charge_resistor)

func _on_line_edit_title_text_submitted(new_text: String) -> void:
	$Panel/MarginContainer/VBoxContainer/Title/HBoxContainer/LineEditTitle.keep_editing_on_text_submit = true
	if new_text.strip_edges().is_empty():
		ErrorMessage.show_error("Name can not be a whitespace")
		$Panel/MarginContainer/VBoxContainer/Title/HBoxContainer/LineEditTitle.text = old_text_title
		return
	
	ref.title = new_text
	old_text_title = new_text
	$Panel/MarginContainer/VBoxContainer/Title/HBoxContainer/LineEditTitle.keep_editing_on_text_submit = false

func _on_line_edit_cap_text_submitted(new_text: String) -> void:
	$Panel/MarginContainer/VBoxContainer/Capacitance/HBoxContainer/LineEditCap.keep_editing_on_text_submit = true
	if !new_text.is_valid_float():
		ErrorMessage.show_error("Invalid value")
		$Panel/MarginContainer/VBoxContainer/Capacitance/HBoxContainer/LineEditCap.text = old_text_cap
		return
	if new_text.to_float() < 0.0:
		ErrorMessage.show_error("Value must be a positive number")
		$Panel/MarginContainer/VBoxContainer/Capacitance/HBoxContainer/LineEditCap.text = old_text_cap
		return
	if new_text.to_float() == 0.0:
		ErrorMessage.show_error("Value can not be 0")
		$Panel/MarginContainer/VBoxContainer/Capacitance/HBoxContainer/LineEditCap.text = old_text_cap
		return
	
	ref.capacitance = new_text.to_float()
	old_text_cap = new_text
	$Panel/MarginContainer/VBoxContainer/Capacitance/HBoxContainer/LineEditCap.keep_editing_on_text_submit = false
	$Panel/MarginContainer/VBoxContainer/Capacitance/HBoxContainer/LineEditCap.text = str(ref.capacitance)

func _on_line_edit_threshold_text_submitted(new_text: String) -> void:
	$Panel/MarginContainer/VBoxContainer/Threshold/HBoxContainer/LineEditThreshold.keep_editing_on_text_submit = true
	if !new_text.is_valid_float():
		ErrorMessage.show_error("Invalid value")
		$Panel/MarginContainer/VBoxContainer/Threshold/HBoxContainer/LineEditThreshold.text = old_text_thr
		return
	if new_text.to_float() < 0.0:
		ErrorMessage.show_error("Value must be a positive number")
		$Panel/MarginContainer/VBoxContainer/Threshold/HBoxContainer/LineEditThreshold.text = old_text_thr
		return
	if new_text.to_float() == 0.0:
		ErrorMessage.show_error("Value can not be 0")
		$Panel/MarginContainer/VBoxContainer/Threshold/HBoxContainer/LineEditThreshold.text = old_text_thr
		return
	
	ref.threshold = new_text.to_float()
	old_text_thr = new_text
	$Panel/MarginContainer/VBoxContainer/Threshold/HBoxContainer/LineEditThreshold.keep_editing_on_text_submit = false
	$Panel/MarginContainer/VBoxContainer/Threshold/HBoxContainer/LineEditThreshold.text = str(ref.threshold)

func _on_line_edit_discharge_prstg_text_submitted(new_text: String) -> void:
	$Panel/MarginContainer/VBoxContainer/DischargePrstg/HBoxContainer/LineEditDischargePrstg.keep_editing_on_text_submit = true
	if !new_text.is_valid_float():
		ErrorMessage.show_error("Invalid value")
		$Panel/MarginContainer/VBoxContainer/DischargePrstg/HBoxContainer/LineEditDischargePrstg.text = old_text_dsg
		return
	if new_text.to_float() < 0.0:
		ErrorMessage.show_error("Value must be a positive number")
		$Panel/MarginContainer/VBoxContainer/DischargePrstg/HBoxContainer/LineEditDischargePrstg.text = old_text_dsg
		return
	if new_text.to_float() == 0.0:
		ErrorMessage.show_error("Value can not be 0")
		$Panel/MarginContainer/VBoxContainer/DischargePrstg/HBoxContainer/LineEditDischargePrstg.text = old_text_dsg
		return
	
	ref.discharge_percent = new_text.to_float()
	old_text_dsg = new_text
	$Panel/MarginContainer/VBoxContainer/DischargePrstg/HBoxContainer/LineEditDischargePrstg.keep_editing_on_text_submit = false
	$Panel/MarginContainer/VBoxContainer/DischargePrstg/HBoxContainer/LineEditDischargePrstg.text = str(ref.discharge_percent)
