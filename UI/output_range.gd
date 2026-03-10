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
