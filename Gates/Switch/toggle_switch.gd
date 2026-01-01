extends GraphNode

signal status_changed(status: bool)

func _ready() -> void:
	set_slot(0, false, 3, Color.DIM_GRAY, true, 3, Color.DIM_GRAY)

func _on_button_toggled(toggled_on: bool) -> void:
	emit_signal("status_changed", toggled_on)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		#get_parent().get_parent().get_parent().get_node("MainMenu").neuron_deleted += 1
		queue_free()
