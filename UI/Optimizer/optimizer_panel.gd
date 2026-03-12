extends Control

var dataset = []
var nodes_order = []
var inputs = []

var output_dataset = []
var output_nodes_order = []
var outputs = []

var weights = []

var learning_rate: = 0.01
var wait_time := 0.5

var split_step: int
@onready var graph_edit = get_parent().get_child(0)
var in_progress: bool = false
@onready var epochs = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Epochs/HBoxContainer/LineEdit.text.to_int()

var steps_selected = []

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
	var rng = RandomNumberGenerator.new()
	
	for node in graph_edit.get_children():
		if node is GraphNode:
			if node.type == "Input":
				if !node.is_constant:
					inputs.append(node)
			if node.type == "RateDetector":
				outputs.append(node)
			if node.type == "SynapticWeight":
				weights.append(node)
	
	if !in_progress:
		in_progress = true
		var s: int = 0
		var rolled_percentage = 0.0
		if $"Panel/MarginContainer/HBoxContainer/VBoxContainer/Loss functions options/HBoxContainer/OptionButton".get_selected_id() == -1:
			in_progress = false
			return
		for i in range(epochs):
			var y_predicted = []
			
			s = rng.randi_range(0, split_step - 1)
			
			if !steps_selected.has(s):
				steps_selected.append(s)
				rolled_percentage = (steps_selected.size() / float(split_step)) * 100
			
			$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Epochs/MarginContainer/VBoxContainer/Label.text = "Epoch: " + str(i + 1)
			$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Epochs/MarginContainer/VBoxContainer/ProgressBar.value = remap(i+1, 0, epochs, 0, 100)
			$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Explored/MarginContainer/VBoxContainer/ProgressBar.value = rolled_percentage
			
			forward_pass(s)
			
			var y = []
			for j in range(output_dataset.size()):
				y.append(output_dataset[j][s])
			
			await get_tree().create_timer(wait_time).timeout
			
			for output in outputs:
				y_predicted.append(output.rate)
			
			var loss
			var index = $"Panel/MarginContainer/HBoxContainer/VBoxContainer/Loss functions options/HBoxContainer/OptionButton".get_selected_id()
			match index:
				1:
					loss = mse_loss(y, y_predicted)
				2:
					loss = mae_loss(y, y_predicted)
				4:
					loss = cross_entropy_loss()
				5:
					loss = binary_cross_entropy_loss()
			
			$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Loss/HBoxContainer/Label.text = "Loss: " + str(loss)
			
			var X = []
			
			for j in range(nodes_order.size()):
				X.append(dataset[j][s])
			
			var gradient
			gradient = gradient_calculation(loss, y.size(), X)
			
			$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Gradient/HBoxContainer/Label.text = "Gradient: " + str(gradient)
			
			for weight in weights:
				weight.update_weight(gradient * learning_rate)
			
		forward_pass(-1)
		$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Epochs/MarginContainer/VBoxContainer/Label.text = "Epoch: "
		$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Epochs/MarginContainer/VBoxContainer/ProgressBar.value = 0
		$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Loss/HBoxContainer/Label.text = "Loss: "
		$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Gradient/HBoxContainer/Label.text = "Gradient: "
		$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Explored/MarginContainer/VBoxContainer/ProgressBar.value = 0
		
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

func gradient_calculation(loss, n: float, X):
	var XmultLoss = multiply_matrixes(X, loss)
	var sum: float = 0.0
	for v in XmultLoss:
		sum += v
	return (2/n) * sum

func multiply_matrixes(matrix, matrix2):
	var arr = []
	for i in range(0, matrix.size() - 1):
		arr.append(matrix[i] * matrix2[i])
	return arr

func mse_loss(y, y_predicted):
	var loss = []
	
	for i in range(0, y.size() - 1):
		var diff = y[i] - y_predicted[i]
		loss.append((diff**2)/y.size())
	
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


func _on_reset_button_pressed() -> void:
	for node in graph_edit.get_children():
		if node is GraphNode:
			if node.type == "SynapticWeight":
				node.set_weight(0.001)
	

func _on_learning_rate_line_edit_text_submitted(new_text: String) -> void:
	learning_rate = new_text.to_float()

func _on_wait_time_line_edit_text_submitted(new_text: String) -> void:
	wait_time = new_text.to_float()
