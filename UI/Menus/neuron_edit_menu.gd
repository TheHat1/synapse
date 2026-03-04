extends Control

var ref: GraphNode

func _ready() -> void:
	$Panel/MarginContainer/VBoxContainer/Title/HBoxContainer/LineEdit.text = ref.title
	$Panel/MarginContainer/VBoxContainer/Capacitance/HBoxContainer/LineEdit.text = str(ref.capacitance)
	$Panel/MarginContainer/VBoxContainer/Threshold/HBoxContainer/LineEdit.text = str(ref.threshold)
	$Panel/MarginContainer/VBoxContainer/Vsrc/HBoxContainer/Label2.text = str(ref.V_src)
	$Panel/MarginContainer/VBoxContainer/DischargeR/HBoxContainer/Label2.text = str(ref.discharge_resistor)
	$Panel/MarginContainer/VBoxContainer/ChargeR/HBoxContainer/Label2.text = str(ref.charge_resistor)
