extends GraphEdit

var menu 
var isMenuOpen = false

func _ready() -> void:
	size = get_viewport().get_visible_rect().size

func _input(event: InputEvent):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if !isMenuOpen:
			menu = load("res://UI/add_elements_menu.tscn").instantiate()
			menu.global_position = event.global_position
			add_child(menu)
			isMenuOpen = true
		else:
			menu.global_position = event.global_position
	elif event is InputEventMouseButton and event.is_pressed() and !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if is_instance_valid(menu):
			menu.queue_free()
		isMenuOpen = false

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
