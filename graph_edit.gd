extends GraphEdit

var neuron = load("res://Neuron/neuron.tscn")

func _ready() -> void:
	size = get_viewport().get_visible_rect().size
	

func _input(event: InputEvent):
	if event is InputEventKey and Input.is_key_pressed(KEY_R):
		var node = neuron.instantiate()
		node.global_position = get_global_mouse_position()
		add_child(node)

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)

func trigger_from(from_node: StringName, from_port: int):
	for connection in get_connection_list():
		if connection.from_node == from_node and connection.from_port == from_port:
			var target := get_node(NodePath(connection.to_node))
			if target.has_method("execute_input"):
				target.execute_input(connection.to_port)
