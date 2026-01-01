extends Control

var neuron = load("res://Neuron/neuron.tscn")
var input = load("res://Input/Input.tscn")
var synaptic_weight = load("res://Synaptic-weight/synaptic-weight.tscn")
var rate_detector = load("res://Rate detector/rate_detector.tscn")
var spike_gate = load("res://Gates/Spike gate/SpikeGate.tscn")
var tbutton = load("res://Gates/Switch/ToggleSwitch.tscn")

func _on_button_pressed() -> void:
	var n = neuron.instantiate()
	n.position_offset = position
	n.title += " " + str(get_parent().get_parent().get_parent().get_node("MainMenu").neuron_count)
	get_parent().add_child(n)
	get_parent().get_parent().get_parent().get_node("MainMenu").neuron_count += 1
	get_parent().close_menu_after_inst()

func _on_button_2_pressed() -> void:
	var i = input.instantiate()
	i.position_offset = position
	i.title += " " + str(get_parent().get_parent().get_parent().get_node("MainMenu").input_count)
	get_parent().add_child(i)
	get_parent().get_parent().get_parent().get_node("MainMenu").input_count += 1
	get_parent().close_menu_after_inst()

func _on_button_3_pressed() -> void:
	var w = synaptic_weight.instantiate()
	w.position_offset = position
	get_parent().add_child(w)
	get_parent().get_parent().get_parent().get_node("MainMenu").weight_count += 1
	get_parent().close_menu_after_inst()

func _on_button_4_pressed() -> void:
	var rd = rate_detector.instantiate()
	rd.position_offset = position
	rd.title += " " + str(get_parent().get_parent().get_parent().get_node("MainMenu").rate_detector_count)
	get_parent().add_child(rd)
	get_parent().get_parent().get_parent().get_node("MainMenu").rate_detector_count += 1
	get_parent().close_menu_after_inst()


func _on_button_5_pressed() -> void:
	$Panel2.visible = !$Panel2.visible

func _on_spike_gate_button_pressed() -> void:
	var sg = spike_gate.instantiate()
	sg.position_offset = position
	get_parent().add_child(sg)
	#get_parent().get_parent().get_parent().get_node("MainMenu").rate_detector_count += 1
	get_parent().close_menu_after_inst()


func _on_toggle_switch_button_pressed() -> void:
	var tb = tbutton.instantiate()
	tb.position_offset = position
	get_parent().add_child(tb)
	#get_parent().get_parent().get_parent().get_node("MainMenu").rate_detector_count += 1
	get_parent().close_menu_after_inst()
