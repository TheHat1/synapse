extends Panel

var minimal = 0.0
var maximum = 10.0
var color:= Color.WHITE
var node_name: String
var node_title: String

func _ready() -> void:
	var base_style = $Panel.get_theme_stylebox("panel")
	var unique_style = base_style.duplicate(true)
	$Panel.add_theme_stylebox_override("panel", unique_style)
	
	$Panel/MarginContainer/Label.text = node_title
	$MarginContainer/HBoxContainer/min.text = str(minimal, 2)
	$MarginContainer/HBoxContainer/max.text = str(maximum, 2)

func _on_button_pressed() -> void:
	queue_free()

func _on_color_picker_button_color_changed(c: Color) -> void:
	$Panel.get_theme_stylebox("panel").bg_color = c
	color = c

func on_node_params_changed(min1: float, max1: float):
	minimal = min1
	maximum = max1
	$MarginContainer/HBoxContainer/min.text = str(minimal, 2)
	$MarginContainer/HBoxContainer/max.text = str(maximum, 2)
