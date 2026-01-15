extends Control

var range_element = load("res://UI/range_element.tscn")
var ranges:= []
var hypercube:= []

func _ready() -> void:
	size = get_viewport().get_visible_rect().size

func _on_button_pressed() -> void:
	$Panel/MarginContainer/HBoxContainer/OptionsBox/Ranges.add_child(range_element.instantiate())

func _on_generate_button_pressed() -> void:
	var range_elements = $Panel/MarginContainer/HBoxContainer/OptionsBox/Ranges.get_children()
	var normaliza = $Panel/MarginContainer/HBoxContainer/OptionsBox/DataNorm/HBoxContainer/DataNormButton.button_pressed
	var N = $Panel/MarginContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/DataNormButton.text.to_int()
	for r in range_elements:
		ranges.append({"min": r.minimal,"max": r.maximum})
	
