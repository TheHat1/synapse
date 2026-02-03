extends Control

var range_element = load("res://UI/range_element.tscn")
var hypercube:= []

func _ready() -> void:
	size = get_viewport().get_visible_rect().size

func _on_button_pressed() -> void:
	$Panel/MarginContainer/HBoxContainer/OptionsBox/ScrollContainer/Ranges.add_child(range_element.instantiate())

func _on_generate_button_pressed() -> void:
	hypercube = []
	var range_elements = $Panel/MarginContainer/HBoxContainer/OptionsBox/ScrollContainer/Ranges.get_children()
	var normalize = $Panel/MarginContainer/HBoxContainer/OptionsBox/DataNorm/HBoxContainer/DataNormButton.button_pressed
	var dds = $Panel/MarginContainer/HBoxContainer/OptionsBox/DDS/HBoxContainer/DataNormButton.button_pressed
	var N = $Panel/MarginContainer/HBoxContainer/OptionsBox/SplitN/HBoxContainer/DataNormButton.text.to_int()
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
		hypercube.append(range_steps)
		range_steps = []
	for i in hypercube.size():
		if i != 0: 
			for j in range(0, i):
				var value_start = hypercube[i].pop_front()
				hypercube[i].append(value_start)
	$Panel/MarginContainer/HBoxContainer/GraphDisplay/MarginContainer/Control.pass_hypercube(hypercube, colors, N)
	$Panel/MarginContainer/HBoxContainer/GraphDisplay/Label.text = "Input ranges' 2D hypercube representation: split_steps: "+ str(N) +", data_norm: "+ str(normalize) +", dds: " + str(dds)
