extends Control

var range_element = load("res://UI/range_element.tscn")
var hypercubeIR:= []
var hypercubeOR:= []

func _ready() -> void:
	size = get_viewport().get_visible_rect().size

func _on_button_pressed() -> void:
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/ScrollContainer/Ranges.add_child(range_element.instantiate())

func _on_generate_button_pressed() -> void:
	hypercubeIR = []
	var range_elements = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/ScrollContainer/Ranges.get_children()
	var normalize = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/DataNorm/HBoxContainer/DataNormButton.button_pressed
	var dds =$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/DDS/HBoxContainer/DataNormButton .button_pressed
	var N = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.text.to_int()
	var rng = RandomNumberGenerator.new()
	var colors = []
	
	for r in range_elements:
		colors.append(r.color)
	
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
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/GraphDisplay/MarginContainer/Control.pass_hypercube(hypercubeIR, colors, N)
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/GraphDisplay/Label.text = "Input ranges' 2D hypercube representation: split_steps: "+ str(N) +", data_norm: "+ str(normalize) +", dds: " + str(dds)

func _on_generate_button_or_pressed() -> void:
	hypercubeOR = []
	var range_elements = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/OptionsBox/ScrollContainer/Ranges.get_children()
	var N = $Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/SplitStep.text.to_int()
	var colors = []
	
	for r in range_elements:
		colors.append(r.color)
	
	for r in range_elements:
		
		var range_steps = []
		
		for i in range(1, N+1):
			pass
		hypercubeOR.append(range_steps)
		range_steps = []
