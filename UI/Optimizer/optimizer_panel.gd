extends Control

var dataset = []
var nodes_order = []
var inputs = []

var output_dataset = []
var output_nodes_order = []
var weights = []

var split_step: int
@onready var graph_edit = get_parent().get_child(0)
var in_progress: bool = false
@onready var epochs = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Epochs/HBoxContainer/LineEdit.text.to_int()

func _ready() -> void:
	size = get_viewport().get_visible_rect().size

func pass_dataset(dtst, nds_ord, n):
	dataset = dtst
	nodes_order = nds_ord
	split_step = n

func pass_output_dataset(outp_dtst, out_nds_ord):
	output_dataset = outp_dtst
	output_nodes_order = out_nds_ord

func _on_start_button_pressed() -> void:
	epochs = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Epochs/HBoxContainer/LineEdit.text.to_int()
	train_network()

func train_network():
	for node in graph_edit.get_children():
		if node is GraphNode:
			if node.type == "Input":
				if !node.is_constant:
					inputs.append(node)
	
	if !in_progress:
		in_progress = true
		var s: int = 0
		if $"Panel/MarginContainer/HBoxContainer/VBoxContainer/Loss functions options/HBoxContainer/OptionButton".get_selected_id() == -1:
			in_progress = false
			return
	
		for i in range(epochs):
			if s == split_step:
				s = 0
			print("Epoch: ", i)
			forward_pass(s)
			var loss
			var index = $"Panel/MarginContainer/HBoxContainer/VBoxContainer/Loss functions options/HBoxContainer/OptionButton".get_selected_id()
			match index:
				1:
					loss = mse_loss([100],[3,2,1])
				2:
					loss = mae_loss([1,2,3],[3,2,1])
				4:
					loss = cross_entropy_loss()
				5:
					loss = binary_cross_entropy_loss()
			s += 1
		forward_pass(-1)
		in_progress = false

func forward_pass(step: int):
	if step == -1:
		for input in inputs:
			input.set_value_on_forward_pass(0)
		return
	
	for i in range(nodes_order.size()):
		for input in inputs:
			if input.name == nodes_order[i]:
				input.set_value_on_forward_pass(dataset[i][step])

func mse_loss(y, y_predicted):
	var sum = 0
	
	for i in range(y.size()):
		var diff = y[i] - y_predicted[i]
		sum += diff * diff
	
	var loss = sum / y.size()
	return loss

func mae_loss(y, y_predicted):
	var sum = 0
	
	for i in range(y.size()):
		var diff = y[i] - y_predicted[i]
		sum += abs(diff)
	
	var loss = sum / y.size()
	return loss

func cross_entropy_loss():
	print("Nuh-uhh brother")

func binary_cross_entropy_loss():
	print("Nuh-uhh brother")
