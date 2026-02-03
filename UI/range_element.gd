extends Panel

var minimal = 0.0
var maximum = 10.0
var color:= Color.WHITE

func _ready() -> void:
	var base_style := get_theme_stylebox("panel")
	var unique_style := base_style.duplicate(true)
	add_theme_stylebox_override("panel", unique_style)

func _on_button_pressed() -> void:
	queue_free()

func _on_min_text_submitted(new_text: String) -> void:
	if new_text.to_float() >= 0:
		minimal = new_text.to_float()

func _on_max_text_submitted(new_text: String) -> void:
	if new_text.to_float() >= 0 and new_text.to_float() > minimal:
		maximum = new_text.to_float()

func _on_color_picker_button_color_changed(c: Color) -> void:
	get_theme_stylebox("panel").bg_color = c
	color = c
