extends Control

var neuron = load("res://Neuron/neuron.tscn")
var input = load("res://Input/Input.tscn")
var synaptic_weight = load("res://Synaptic-weight/synaptic-weight.tscn")
var rate_detector = load("res://Rate detector/rate_detector.tscn")
var spike_gate = load("res://Gates/Spike gate/SpikeGate.tscn")
var tbutton = load("res://Gates/Switch/ToggleSwitch.tscn")
var input_neuron = load("res://Neuron/input_neuron.tscn")
var resistor = load("res://Resistor/Resistor.tscn")

func _on_button_pressed() -> void:
	$Neurons.visible = !$Neurons.visible
	$Gates.visible = false

func _on_button_2_pressed() -> void:
	var i = input.instantiate()
	i.position_offset = (get_parent().get_local_mouse_position() + get_parent().scroll_offset) / get_parent().zoom - i.size / Vector2(2,2)
	i.title += " " + str(get_parent().get_parent().get_parent().get_node("MainMenu").input_count)
	get_parent().add_child(i)
	get_parent().get_parent().get_parent().get_node("MainMenu").input_count += 1
	get_parent().close_menu_after_inst()

func _on_button_3_pressed() -> void:
	var w = synaptic_weight.instantiate()
	w.position_offset = (get_parent().get_local_mouse_position() + get_parent().scroll_offset) / get_parent().zoom - w.size / Vector2(2,2)
	get_parent().add_child(w)
	get_parent().get_parent().get_parent().get_node("MainMenu").weight_count += 1
	get_parent().close_menu_after_inst()

func _on_button_4_pressed() -> void:
	var rd = rate_detector.instantiate()
	rd.position_offset = (get_parent().get_local_mouse_position() + get_parent().scroll_offset) / get_parent().zoom - rd.size / Vector2(2,2)
	rd.title += " " + str(get_parent().get_parent().get_parent().get_node("MainMenu").rate_detector_count)
	get_parent().add_child(rd)
	get_parent().get_parent().get_parent().get_node("MainMenu").rate_detector_count += 1
	get_parent().close_menu_after_inst()


func _on_button_5_pressed() -> void:
	$Gates.visible = !$Gates.visible
	$Neurons.visible = false

func _on_spike_gate_button_pressed() -> void:
	var sg = spike_gate.instantiate()
	sg.position_offset = (get_parent().get_local_mouse_position() + get_parent().scroll_offset) / get_parent().zoom - sg.size / Vector2(2,2)
	get_parent().add_child(sg)
	#get_parent().get_parent().get_parent().get_node("MainMenu").rate_detector_count += 1
	get_parent().close_menu_after_inst()


func _on_toggle_switch_button_pressed() -> void:
	var tb = tbutton.instantiate()
	tb.position_offset = (get_parent().get_local_mouse_position() + get_parent().scroll_offset) / get_parent().zoom - tb.size / Vector2(2,2)
	get_parent().add_child(tb)
	#get_parent().get_parent().get_parent().get_node("MainMenu").rate_detector_count += 1
	get_parent().close_menu_after_inst()

func _on_neuron_button_pressed() -> void:
	var n = neuron.instantiate()
	n.position_offset = (get_parent().get_local_mouse_position() + get_parent().scroll_offset) / get_parent().zoom - n.size / Vector2(2,2)
	n.title += " " + str(get_parent().get_parent().get_parent().get_node("MainMenu").neuron_count)
	get_parent().add_child(n)
	get_parent().get_parent().get_parent().get_node("MainMenu").neuron_count += 1
	get_parent().close_menu_after_inst()

func _on_input_neuron_button_pressed() -> void:
	var i_n = input_neuron.instantiate()
	i_n.position_offset = (get_parent().get_local_mouse_position() + get_parent().scroll_offset) / get_parent().zoom - i_n.size / Vector2(2,2)
	i_n.title += " " + str(get_parent().get_parent().get_parent().get_node("MainMenu").neuron_count)
	get_parent().add_child(i_n)
	get_parent().get_parent().get_parent().get_node("MainMenu").neuron_count += 1
	get_parent().close_menu_after_inst()


func _on_button_6_pressed() -> void:
	var r = resistor.instantiate()
	r.position_offset = (get_parent().get_local_mouse_position() + get_parent().scroll_offset) / get_parent().zoom - r.size / Vector2(2,2)
	get_parent().add_child(r)
	#get_parent().get_parent().get_parent().get_node("MainMenu").rate_detector_count += 1
	get_parent().close_menu_after_inst()
