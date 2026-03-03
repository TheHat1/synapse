extends Control

var neuron_representer = load("res://UI/Telemetry/Misc/NeuronRepresenter.tscn")
var weight_representer = load("res://UI/Telemetry/Misc/SynapticWeightRepresenter.tscn")
var rate_detector_representer = load("res://UI/Telemetry/Misc/RateDetectorRepresenter.tscn")

var fadeTime: float = 500.0
var activationsPerSecond: float
@onready var visible_center = $Panel/ScrollContainer/MarginContainer/VBoxContainer/TelemetryGraphEdit.size * Vector2(0.065,0.5)
@onready var graphEditRef = get_parent().get_node('GraphEdit')
@onready var telemetryGraphEditRef = $Panel/ScrollContainer/MarginContainer/VBoxContainer/TelemetryGraphEdit
var show_polarity: bool = false

var inhibitory_connections := []

signal fade_time_changed(value: float)

func _ready() -> void:
	size = get_viewport().get_visible_rect().size
	graphEditRef.spike.connect(_on_spike)


func _process(delta: float) -> void:
	activationsPerSecond -= activationsPerSecond * delta
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/Label.text = "Fade time: " + str(fadeTime) + "ms, Activations per second: " + str(snappedf(activationsPerSecond, 0.1)) + ", Clock speed: " + str(Engine.get_frames_per_second()) + "Hz"

func _on_h_slider_value_changed(value: float) -> void:
	fadeTime = value
	emit_signal("fade_time_changed", value / 1000)

func display_network():
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/FadeTime/HBoxContainer/HSlider.value = 500.0
	var representer_nodes = telemetryGraphEditRef.get_children()
	for node in representer_nodes:
		if node is GraphNode:
			telemetryGraphEditRef.remove_child(node)
			node.free()
	telemetryGraphEditRef.clear_connections()
	
	await get_tree().process_frame
	
	var nodes = graphEditRef.get_children()
	var all_connections = graphEditRef.get_connection_list()
	var nodes_selected = []
	for node in nodes:
		if node is GraphNode:
			var nd: GraphNode
			var offset: Vector2
			match(node.type):
				"Neuron":
					nd = neuron_representer.instantiate()
					offset = Vector2(60, 0)
					node.current_buffer_value.connect(nd._current_buffer_value)
					node.pass_activation_treshold.connect(nd._pass_activation_treshold)
				"InputNeuron":
					nd = neuron_representer.instantiate()
					offset = Vector2(60, 0)
					node.current_buffer_value.connect(nd._current_buffer_value)
					node.pass_activation_treshold.connect(nd._pass_activation_treshold)
				"SynapticWeight":
					nd = weight_representer.instantiate()
					offset = Vector2(0, 0)
					node.emit_spike.connect(nd._on_spike)
				"RateDetector":
					nd = rate_detector_representer.instantiate()
					offset = Vector2(60, 0)
					node.current_rate.connect(nd._current_rate)
			if nd is GraphNode:
				nd.name = node.name
				nodes_selected.append(node.name)
				
				nd.position_offset = node.position_offset * Vector2(0.5,0.7) + offset - visible_center
				
				if node.type != "RateDetector":
					self.fade_time_changed.connect(nd._on_fade_time_changed)
				
					var base_style : StyleBoxFlat = nd.get_theme_stylebox("panel").duplicate()
					nd.add_theme_stylebox_override("panel", base_style)
				
				telemetryGraphEditRef.add_child(nd)
	
	for node in nodes_selected:
		for connection in all_connections:
			if connection["from_node"] == node:
				telemetryGraphEditRef.connect_node(connection["from_node"], 0, connection["to_node"], 0)
				if graphEditRef.get_node(NodePath(connection["to_node"])).type == "Neuron" :
					if connection["to_port"] == 0:
						inhibitory_connections.append(connection)
	
	if show_polarity:
		set_connection_polarity_color(show_polarity)

func _on_spike():
	activationsPerSecond += 1

func _on_show_polarity_button_toggled(toggled_on: bool) -> void:
	show_polarity = toggled_on
	set_connection_polarity_color(show_polarity)

func set_connection_polarity_color(val: bool):
	if val:
		for connection in inhibitory_connections:
			telemetryGraphEditRef.set_connection_activity(connection["from_node"], connection["from_port"], connection["to_node"], connection["to_port"], 1)
	else:
		for connection in inhibitory_connections:
			telemetryGraphEditRef.set_connection_activity(connection["from_node"], connection["from_port"], connection["to_node"], connection["to_port"], 0)
