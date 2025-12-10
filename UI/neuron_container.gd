extends HBoxContainer

var neuron = load("res://Neuron/neuron.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var n = neuron.instantiate()
		n.position_offset = get_parent().get_parent().get_parent().get_parent().get_child(0).to_local(event.position) * get_parent().get_parent().get_parent().get_parent().zoom
		get_parent().get_parent().get_parent().get_parent().add_child(n)
