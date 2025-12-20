extends Control

var neuron = load("res://Neuron/neuron.tscn")
var pacemaker = load("res://PaceMaker/PaceMaker.tscn")
var input = load("res://Input/Input.tscn")
var neuron_count = 1
var pacemaker_count = 1
var input_count = 1

func _on_button_pressed() -> void:
	var n = neuron.instantiate()
	n.position_offset = position
	n.title += str(neuron_count)
	get_parent().add_child(n)
	neuron_count = neuron_count + 1
	get_parent().close_menu_after_inst()


func _on_button_2_pressed() -> void:
	var p = pacemaker.instantiate()
	p.position_offset = position
	get_parent().add_child(p)
	get_parent().close_menu_after_inst()


func _on_button_3_pressed() -> void:
	var i = input.instantiate()
	i.position_offset = position
	get_parent().add_child(i)
	get_parent().close_menu_after_inst()
