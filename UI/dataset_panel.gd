extends Control

var range_element = load("res://UI/range_element.tscn")

func _ready() -> void:
	size = get_viewport().get_visible_rect().size

func _on_button_pressed() -> void:
	$Panel/MarginContainer/HBoxContainer/OptionsBox/Ranges.add_child(range_element.instantiate())
