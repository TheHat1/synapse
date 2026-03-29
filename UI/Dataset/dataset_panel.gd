extends Control

var range_element = load("res://UI/range_element.tscn")
var output_range_element = load("res://UI/OutputRange.tscn")
var hypercubeIR:= []
var hypercubeOR:= []
@onready var N = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.text.to_int()
var old_text_N:String

func _ready() -> void:
	size = get_viewport().get_visible_rect().size
	old_text_N = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.text

func _on_generate_button_pressed() -> void:
	hypercubeIR = []
	var range_elements = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/ScrollContainer/Ranges.get_children()
	var normalize = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/DataNorm/HBoxContainer/DataNormButton.button_pressed
	var dds =$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/DDS/HBoxContainer/DataNormButton .button_pressed
	N = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.text.to_int()
	var rng = RandomNumberGenerator.new()
	var colors = []
	var nodes_names = []
	
	for r in range_elements:
		colors.append(r.color)
		nodes_names.append(r.node_name)
	
	for r in range_elements:
		
		var range_steps = []
		var delta = (1.0/N) if normalize else ((r.maximum - r.minimal)/N)
		
		for i in range(1, N+1):
			if normalize:
				if dds:
					range_steps.append((i-0.5) * delta)
				else:
					range_steps.append((i-rng.randf()) * delta)
			else:
				if dds:
					range_steps.append(r.minimal + (i-0.5) * delta)
				else:
					range_steps.append(r.minimal + (i-rng.randf()) * delta)
		hypercubeIR.append(range_steps)
		range_steps = []
	for i in hypercubeIR.size():
		if i != 0: 
			for j in range(0, i):
				var value_start = hypercubeIR[i].pop_front()
				hypercubeIR[i].append(value_start)
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/GraphDisplay/MarginContainer/Control.pass_hypercube(hypercubeIR, colors)
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/GraphDisplay/Label.text = "Input ranges' 2D hypercube representation: split_steps: "+ str(N) +", data_norm: "+ str(normalize) +", dds: " + str(dds)
	get_parent().get_node("OptimizerPanel").pass_dataset(hypercubeIR, nodes_names, N)

func _on_generate_button_or_pressed() -> void:
	hypercubeOR = []
	var range_elements = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/OptionsBox/ScrollContainer/Ranges.get_children()
	var colors = []
	var nodes_names = []
	
	for r in range_elements:
		colors.append(r.color)
		nodes_names.append(r.node_name)
	
	var regex := RegEx.new()
	regex.compile("^-?\\d+:-?\\d+(?:\\.\\d+)?(?:,\\s*-?\\d+:-?\\d+(?:\\.\\d+)?)*$")
	
	for r in range_elements:
		
		var range_places = []
		
		if !regex.search(r.text):
			ErrorMessage.show_error("Inavalid syntax for: " + r.node_title)
			return
		
		var text = r.text.replace(" ", "")
		var text_arr = text.split(",")
		
		for element in text_arr:
			range_places.append(element.split(":"))
		
		hypercubeOR.append(range_places)
		range_places = []
	var cube = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/GraphDisplay/MarginContainer/Control.pass_hypercube(hypercubeOR, colors)
	get_parent().get_node("OptimizerPanel").pass_output_dataset(cube, nodes_names)

func _on_split_step_text_submitted(new_text: String) -> void:
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.keep_editing_on_text_submit = true
	if !new_text.is_valid_float():
		ErrorMessage.show_error("Invalid value for N")
		$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.text = old_text_N
		return
	if !new_text.is_valid_int():
		ErrorMessage.show_error("Value must be an integer for N")
		$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.text = old_text_N
		return
	if new_text.to_int() < 0.0:
		ErrorMessage.show_error("Value must be a positive number for N")
		$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.text = old_text_N
		return
	if new_text.to_int() == 0.0: 
		ErrorMessage.show_error("Value can not be 0 for N")
		$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.text = old_text_N
		return
	
	N = new_text.to_int()
	old_text_N = new_text
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.keep_editing_on_text_submit = false
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/GraphDisplay/MarginContainer/Control.pass_steps(N)
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/GraphDisplay/MarginContainer/Control.pass_steps(N)

var current_input_nodes = [["",0.0,0.0]]

func get_inputs():
	var nodes = get_parent().get_child(0).get_children()
	for node in nodes:
		if node is GraphNode:
			if node.type == "Input":
				if !node.is_constant:
					check_if_node_has_changed(current_input_nodes, node)

func remove_input_node(node_name: String):
	current_input_nodes.erase(node_name)
	var nodes = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/ScrollContainer/Ranges.get_children()
	for node in nodes:
		if node.node_name == node_name:
			node.queue_free()

var current_output_nodes = [""]

func get_outputs():
	var nodes = get_parent().get_child(0).get_children()
	for node in nodes:
		if node is GraphNode:
			if node.type == "RateDetector":
				if !current_output_nodes.has(node.name):
					current_output_nodes.append(node.name)
					var r = output_range_element.instantiate()
					r.node_name = node.name
					r.node_title = node.title
					$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/OptionsBox/ScrollContainer/Ranges.add_child(r)

func remove_output_node(node_name: String):
	current_output_nodes.erase(node_name)
	var nodes = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/OptionsBox/ScrollContainer/Ranges.get_children()
	for node in nodes:
		if node.node_name == node_name:
			node.queue_free()

func check_if_node_has_changed(arr, node):
	var exists: bool = false
	for i in range(arr.size()):
		if arr[i][0] == node.name:
			exists = true
			var ranges = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/ScrollContainer/Ranges.get_children()
			for r in ranges:
				if r.node_name == node.name:
					if r.minimal != node.minV or r.maximum != node.maxV:
						r.on_node_params_changed(node.minV , node.maxV )
	if !exists:
		arr.append([node.name, node.minV, node.maxV])
		var r = range_element.instantiate()
		r.node_name = node.name
		r.node_title = node.title
		r.minimal = node.minV
		r.maximum = node.maxV
		$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/ScrollContainer/Ranges.add_child(r)
