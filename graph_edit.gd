extends GraphEdit

var menu 
var isMenuOpen = false

signal spike()

func _ready() -> void:
	size = get_viewport().get_visible_rect().size

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if !isMenuOpen:
			menu = load("res://UI/Menus/add_elements_menu.tscn").instantiate()
			menu.global_position = event.global_position
			add_child(menu)
			isMenuOpen = true
		else:
			menu.global_position = event.global_position
	elif event is InputEventMouseButton and is_instance_valid(menu) and event.is_pressed() and !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and !$"AddElementsMenu".get_global_rect().has_point(event.position):
		if is_instance_valid(menu):
			menu.queue_free()
		isMenuOpen = false

func close_menu_after_inst():
	if is_instance_valid(menu):
		menu.queue_free()
	isMenuOpen = false

func _wire_connection(from_node: StringName, from_port: int, to_node: StringName, _to_port: int):
	var from = $".".get_node(NodePath(from_node))
	var to = $".".get_node(NodePath(to_node))
	
	match from.get_output_port_type(from_port):
		1:
			from.value_changed_resistor.connect(to._on_value_changed)
		3:
			from.status_changed.connect(to._on_gate_status_change)
		4:
			from.v_src_changed.connect(to._on_v_src_changed)

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	_wire_connection(from_node, from_port, to_node, to_port)
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if $".".get_node(NodePath(from_node)).get_output_port_type(from_port) == 1:
		$".".get_node(NodePath(from_node)).disconnect("value_changed", get_node(NodePath(to_node))._on_value_changed)
	if $".".get_node(NodePath(from_node)).get_output_port_type(from_port) == 3:
		$".".get_node(NodePath(from_node)).disconnect("status_changed", get_node(NodePath(to_node))._on_gate_status_change)
	disconnect_node(from_node, from_port, to_node, to_port)

func trigger_from(from_node: StringName, from_port: int, weight: float):
	if get_node(NodePath(from_node)).type == "Neuron" or get_node(NodePath(from_node)).type == "InputNeuron":
		emit_signal("spike")
	for connection in get_connection_list():
		if connection.from_node == from_node and connection.from_port == from_port:
			var target := get_node(NodePath(connection.to_node))
			if target.has_method("execute_input"):
				target.execute_input(connection.to_port, weight)

func change_activation_sound(path: String):
	for node in get_children():
		if node.has_method("change_sound"):
			node.change_sound(path)
