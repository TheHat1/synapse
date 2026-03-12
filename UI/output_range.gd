extends Panel

var color:= Color.WHITE
var text: String

var node_name: String
var node_title: String

func _ready() -> void:
	var base_style = $Panel.get_theme_stylebox("panel")
	var unique_style = base_style.duplicate(true)
	$Panel.add_theme_stylebox_override("panel", unique_style)
	
	$Panel/MarginContainer/Label.text = node_title

func _on_button_pressed() -> void:
	queue_free()

func _on_color_picker_button_color_changed(c: Color) -> void:
	$Panel.get_theme_stylebox("panel").bg_color = c
	color = c

func _on_line_edit_text_submitted(new_text: String) -> void:
	text = new_text

func set_text_on_load(val: String):
	text = val
	$MarginContainer/HBoxContainer/LineEdit.text = val

func set_color_on_load(c: String):
	c = c.replace('(','')
	c = c.replace(')','')
	var ca = c.split(',')
	$Panel.get_theme_stylebox("panel").bg_color = Color(ca[0].to_float(), ca[1].to_float(), ca[2].to_float())
	color = Color(ca[0].to_float(), ca[1].to_float(), ca[2].to_float())
