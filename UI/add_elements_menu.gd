extends Control

var neuron = load("res://Neuron/neuron.tscn")
var pacemaker = load("res://PaceMaker/PaceMaker.tscn")
var input = load("res://Input/Input.tscn")

func _on_button_pressed() -> void:
	var n = neuron.instantiate()
	n.position_offset = position
	get_parent().add_child(n)
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
