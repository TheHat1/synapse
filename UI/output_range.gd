extends Panel

var color:= Color.WHITE
var text: String

func _ready() -> void:
	var base_style := get_theme_stylebox("panel")
	var unique_style := base_style.duplicate(true)
	add_theme_stylebox_override("panel", unique_style)

func _on_button_pressed() -> void:
	queue_free()

func _on_color_picker_button_color_changed(c: Color) -> void:
	get_theme_stylebox("panel").bg_color = c
	color = c

func _on_line_edit_text_submitted(new_text: String) -> void:
	text = new_text
