extends Control

var dataset = []
var nodes_order = []
var inputs = []

var output_dataset = []
var output_nodes_order = []
var outputs = []

var y = [] ##Wanted activation matrix
var x = [] ##Input matrix

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
	if !in_progress:
		in_progress = true
		
		ErrorMessage.show_error("Training started")
		
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
		
		var s: int = 0
		if $"Panel/MarginContainer/HBoxContainer/VBoxContainer/Loss functions options/HBoxContainer/OptionButton".get_selected_id() == -1:
			in_progress = false
			return
		
		##Transpose the output matrix
		for i in range(split_step):
			var arr = []
			for j in range(output_dataset.size()):
				arr.append(output_dataset[j][i])
			y.append(arr)
	
		for epoch in range(epochs):
			var y_predicted = []
			var loss
			var rolled_percentage = 0.0
			
			$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Epochs/MarginContainer/VBoxContainer/Label.text = "Epoch: " + str(epoch + 1)
			$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Epochs/MarginContainer/VBoxContainer/ProgressBar.value = remap(epoch+1, 0, epochs, 0, 100)
			
			for i in range(split_step):
				
				s = rng.randi_range(0, split_step - 1)
				
				if !steps_selected.has(s):
					steps_selected.append(s)
					rolled_percentage = (steps_selected.size() / float(split_step)) * 100
				
				$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Explored/MarginContainer/VBoxContainer/ProgressBar.value = rolled_percentage
				
				forward_pass(s)
				
				await get_tree().create_timer(wait_time).timeout
				
				var arr = []
				for output in outputs:
					arr.append(output.rate)
				y_predicted.append(arr)
			################################################
			##End of forward pass
			
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
				
			$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Loss/HBoxContainer/Label.text = "Loss: " + str(loss).remove_chars('[]')
			
			var gradient
			gradient = gradient_calculation(loss, dataset)
			################################################
			##End of gradient calculation
			
			$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Gradient/HBoxContainer/Label.text = "Gradient: " + str(gradient).remove_chars('[]')
			
			for connection in graph_edit.get_connection_list():
				if connection.to_port == 0:
					for output in outputs:
						if connection.to_node == output.name:
							print(connection)
							for weight in weights:
								if connection.from_node == weight.name:
									print("gotta get that boom boom boom")
									weights.update_weight(gradient[1] * learning_rate)
			
		forward_pass(-1)
		in_progress = false
		ErrorMessage.show_error("Training finished")
	else:
		ErrorMessage.show_error("Training in progress")

func forward_pass(step: int):
	if step == -1:
		for input in inputs:
			input.set_value_on_forward_pass(0)
		return
	
	for i in range(nodes_order.size()):
		for input in inputs:
			if input.name == nodes_order[i]:
				input.set_value_on_forward_pass(dataset[i][step])

func gradient_calculation(loss, X):
	var gradient = []
	
	for i in range(X.size()):
		var sum: float = 0.0
		for j in range(split_step):
			sum += X[i][j] * loss[i]
		gradient.append((2/float(split_step)) * sum)
	
	return gradient

func mse_loss(y1, y_predicted):
	var loss = []
	
	for j in range(outputs.size()):
		var n = 0
		var arr = []
		var diff: = 0.0
		
		for i in range(y.size()):
			diff = (y1[i][j] - y_predicted[i][j])**2
			arr.append(diff)
			n +=1
		
		loss.append(diff/n)
	
	return loss

func mae_loss(y1, y_predicted):
	var loss = []
	
	for j in range(outputs.size()):
		var n = 0
		var arr = []
		var diff: = 0.0
		
		for i in range(y.size()):
			diff = abs(y1[i][j] - y_predicted[i][j])
			arr.append(diff)
			n +=1
		
		loss.append(diff/n)
	
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
	ErrorMessage.show_error("Weights reset")

func _on_learning_rate_line_edit_text_submitted(new_text: String) -> void:
	learning_rate = new_text.to_float()

func _on_wait_time_line_edit_text_submitted(new_text: String) -> void:
	wait_time = new_text.to_float()

func _on_reset_stats_button_pressed() -> void:
	$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Epochs/MarginContainer/VBoxContainer/Label.text = "Epoch: "
	$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Epochs/MarginContainer/VBoxContainer/ProgressBar.value = 0
	$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Loss/HBoxContainer/Label.text = "Loss: "
	$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Gradient/HBoxContainer/Label.text = "Gradient: "
	$Panel/MarginContainer/HBoxContainer/VBoxContainer2/Explored/MarginContainer/VBoxContainer/ProgressBar.value = 0
