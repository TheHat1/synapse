extends Panel

var minimal = 0.0
var maximum = 10.0

func _on_button_pressed() -> void:
	queue_free()

func _on_min_text_submitted(new_text: String) -> void:
	if new_text.to_float() >= 0:
		minimal = new_text.to_float()

func _on_max_text_submitted(new_text: String) -> void:
	if new_text.to_float() >= 0 and new_text.to_float() > minimal:
		maximum = new_text.to_float()
