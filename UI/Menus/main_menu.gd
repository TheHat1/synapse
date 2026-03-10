extends Panel

var neuron_count = 1
var input_count = 1
var weight_count = 1
var rate_detector_count = 1
var neuron_deleted = 1
var input_deleted = 1
var weight_deleted = 1
var rate_detector_deleted = 1

var ref = null
var ref_title: String
var ref_capacitance: String
var ref_threshold: String
var ref_drain: String
var ref_input: String

var neuron = preload("res://Neuron/neuron.tscn")
var input_neuron = preload("res://Neuron/input_neuron.tscn")
var input = preload("res://Input/Input.tscn")
var synaptic_weight = preload("res://Synaptic-weight/synaptic-weight.tscn")
var rate_detector = preload("res://Rate detector/rate_detector.tscn")
var resistor = preload("res://Resistor/Resistor.tscn")

var config = ConfigFile.new()

func _ready() -> void:
	$VBoxContainer/ScrollContainer/VBoxContainer/Panel5/HBoxContainer/OptionButton.set_item_text(0, "Current (" + str(round(DisplayServer.screen_get_refresh_rate())).remove_chars(".0") + " fps)")

func _process(_delta) -> void:
	$VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/Label2.text = str(neuron_count - neuron_deleted)
	$VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer3/Label2.text = str(input_count - input_deleted)
	$VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer5/Label2.text = str(weight_count - weight_deleted)
	$VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer2/Label2.text = str(rate_detector_count - rate_detector_deleted)

func _on_h_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)

func _on_button_pressed() -> void:
	get_tree().quit()

func _on_save_button_pressed() -> void:
	$SaveFileDialog.filters = ["*.json"]
	config.load("res://user_config.cfg")
	$SaveFileDialog.current_path = config.get_value("files", "last_saved_to_dir",  "user://")
	$SaveFileDialog.current_file = "graph_"+ str(config.get_value("files", "files_saved",  "0")) + ".json"
	$SaveFileDialog.popup_centered()

func _on_save_file_dialog_file_selected(path: String) -> void:
	serialize_and_export_graph(path)
	config.set_value("files", "last_saved_to_dir", path.get_base_dir() + "/")
	config.set_value("files", "files_saved", config.get_value("files", "files_saved") + 1)
	config.save("res://user_config.cfg")

func serialize_and_export_graph(path: String):
	var data := {
		"nodes": [], 
		"connections": get_parent().get_node("GraphWrapper").get_child(0).get_connection_list(),
		"dataset_output_points": []
		}
	
	for child in get_parent().get_node("GraphWrapper").get_child(0).get_children():
		if child is GraphNode:
			match (child.type):
				"Neuron": 
					data.nodes.append({
						"name": child.name,
						"title": child.title, 
						"position": child.position_offset, 
						"type": child.type,
						"capacitance": child.capacitance,
						"threshold": child.threshold,
						"discharge_resistor": child.discharge_resistor,
						"charge_resistor": child.charge_resistor
					})
				"InputNeuron":
					data.nodes.append({
						"name": child.name,
						"title": child.title, 
						"position": child.position_offset, 
						"type": child.type,
						"capacitance": child.capacitance,
						"threshold": child.threshold,
						"discharge_resistor": child.discharge_resistor,
						"charge_resistor": child.charge_resistor
					})
				"SynapticWeight": 
					data.nodes.append({
						"name": child.name,
						"title": child.title, 
						"position": child.position_offset, 
						"type": child.type,
						"weight": child.weight
					})
				"Input": 
					data.nodes.append({
						"name": child.name,
						"title": child.title, 
						"position": child.position_offset, 
						"type": child.type,
						"minV": child.minV,
						"maxV": child.maxV,
						"isConstant": child.is_constant
					})
				"RateDetector": 
					data.nodes.append({
						"name": child.name,
						"title": child.title, 
						"position": child.position_offset, 
						"type": child.type,
						"target_hz": child.target_hz
					})
				"Resistor":
					data.nodes.append({
						"name": child.name,
						"title": child.title, 
						"position": child.position_offset, 
						"type": child.type,
						"resistance": child.resistance
					})
				_: print("Opaaa   ", child)
	var ranges = get_parent().get_node("GraphWrapper").get_child(1).get_node("Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/OptionsBox/ScrollContainer/Ranges").get_children()
	for r in ranges:
		data.dataset_output_points.append({"text": r.text})
	
	var json := JSON.stringify(data, '\n')
	
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to save file")
		return
	
	file.store_string(json)
	file.close()

func _on_load_file_dialog_file_selected(path: String) -> void:
	load_graph_from_file(path)

func _on_load_button_pressed() -> void:
	if get_parent().get_node("GraphWrapper").get_child(0).get_children().size() > 1:
		$ConfirmLoadDialog.popup_centered()
	else:
		$LoadFileDialog.filters = ["*.json"]
		config.load("res://user_config.cfg")
		$LoadFileDialog.current_path = config.get_value("files", "last_saved_to_dir",  "user://")
		$LoadFileDialog.current_path = config.get_value("files", "last_saved_to_dir",  "user://")
		$LoadFileDialog.popup_centered()
		$LoadFileDialog.get_ok_button().grab_focus()

func load_graph_from_file(path: String):
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file")
		return
	
	var json_text := file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var _data := json.parse(json_text)
	var data = json.get_data()
	
	for node_data in data.get("nodes", []):
		var node
		match (node_data["type"]):
			"Neuron": 
				node = neuron.instantiate()
				node.capacitance = node_data["capacitance"]
				node.threshold = node_data["threshold"]
				node.discharge_resistor = node_data["discharge_resistor"]
				node.charge_resistor = node_data["charge_resistor"]
				neuron_count +=1
			"InputNeuron":
				node = input_neuron.instantiate()
				node.capacitance = node_data["capacitance"]
				node.threshold = node_data["threshold"]
				node.discharge_resistor = node_data["discharge_resistor"]
				node.charge_resistor = node_data["charge_resistor"]
				neuron_count +=1
			"SynapticWeight": 
				node = synaptic_weight.instantiate()
				node.weight = node_data["weight"]
				weight_count += 1
			"Input": 
				node = input.instantiate()
				node.minV = node_data["minV"]
				node.maxV = node_data["maxV"]
				node.is_constant = node_data["isConstant"]
				input_count += 1
			"RateDetector": 
				node = rate_detector.instantiate()
				node.target_hz = node_data["target_hz"]
				rate_detector_count += 1
			"Resistor":
				node = resistor.instantiate()
				node.resistance = node_data["resistance"]
			_: print("Opaaa   ", node_data)
		
		node.name = node_data["name"]
		node.title = node_data["title"]
		
		var p = node_data.position
		p = p.replace("(", "").replace(")", "")
		p = p.split(",") 
		
		node.position_offset = Vector2(p[0].to_float(), p[1].to_float())
		
		get_parent().get_node("GraphWrapper").get_child(0).add_child(node)
	
	for conn in data.get("connections", []):
		get_parent().get_node("GraphWrapper").get_child(0).connect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
		get_parent().get_node("GraphWrapper").get_child(0)._wire_connection(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
	
	

func _on_confirm_load_dialog_confirmed() -> void:
	get_parent().get_node("GraphWrapper").get_child(0).clear_connections()
	
	for child in get_parent().get_node("GraphWrapper").get_child(0).get_children():
		if child is GraphNode:
			child.queue_free()
	
	neuron_count = 1
	input_count = 1
	rate_detector_count = 1
	weight_count = 1
	
	neuron_deleted = 1
	input_deleted = 1
	rate_detector_deleted = 1
	weight_deleted = 1
	
	$LoadFileDialog.filters = ["*.json"]
	$LoadFileDialog.current_path = config.get_value("files", "last_saved_to_dir",  "user://")
	$LoadFileDialog.popup_centered()

func _on_clear_button_pressed() -> void:
	get_parent().get_node("GraphWrapper").get_child(0).clear_connections()
	
	for child in get_parent().get_node("GraphWrapper").get_child(0).get_children():
		if child is GraphNode:
			child.queue_free()
	
	neuron_count = 1
	input_count = 1
	rate_detector_count = 1
	weight_count = 1
	
	neuron_deleted = 1
	input_deleted = 1
	rate_detector_deleted = 1
	weight_deleted = 1

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			Engine.max_fps = int(floor(DisplayServer.screen_get_refresh_rate()))
		1:
			Engine.max_fps = 60
		2:
			Engine.max_fps = 144
		3:
			Engine.max_fps = 228
		4:
			Engine.max_fps = 0

func _on_sound_option_button_item_selected(index: int) -> void:
	var path: String
	match index:
		0:
			path = "res://Assets/Sounds/sound-2.mp3"
		1: 
			path = "res://Assets/Sounds/sound-1.mp3"
		2:
			path = "res://Assets/Sounds/augghh.mp3"
		3: 
			path = "res://Assets/Sounds/pufferfish.mp3"
	
	get_parent().get_node("GraphWrapper").get_child(0).change_activation_sound(path)
