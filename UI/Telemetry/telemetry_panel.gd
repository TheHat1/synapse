extends Control

var neuron_representer = load("res://UI/Telemetry/Misc/NeuronRepresenter.tscn")
var weight_representer = load("res://UI/Telemetry/Misc/SynapticWeightRepresenter.tscn")

var fadeTime: float = 500.0
var activationsPerSecond: int
var elapsed: = 0.0
@onready var visible_center = $Panel/ScrollContainer/MarginContainer/VBoxContainer/TelemetryGraphEdit.size * Vector2(0.065,0.5)
@onready var graphEditRef = get_parent().get_node('GraphEdit')
@onready var telemetryGraphEditRef = $Panel/ScrollContainer/MarginContainer/VBoxContainer/TelemetryGraphEdit

func _ready() -> void:
	size = get_viewport().get_visible_rect().size

func _process(delta: float) -> void:
	$Panel/ScrollContainer/MarginContainer/VBoxContainer/Label.text = "Fade time: " + str(fadeTime) + "ms, Activations per second: " + str(activationsPerSecond) + ", Clock speed: " + str(Engine.get_frames_per_second()) + "Hz"
	elapsed = elapsed + delta
	if(elapsed >= 1):
		activationsPerSecond = activationsPerSecond - activationsPerSecond
		elapsed = 0.0

func _on_h_slider_value_changed(value: float) -> void:
	fadeTime = value

func display_network():
	var representer_nodes = $Panel/ScrollContainer/MarginContainer/VBoxContainer/TelemetryGraphEdit.get_child(0).get_children()
	for node in representer_nodes:
		node.queue_free()
	
	var nodes = graphEditRef.get_children()
	var all_connections = graphEditRef.get_connection_list()
	var output_connections
	for node in nodes:
		if node is GraphNode:
			var nd: GraphNode
			var offset: Vector2
			match(node.type):
				"Neuron":
					nd = neuron_representer.instantiate()
					offset = Vector2(60, 0)
				"InputNeuron":
					nd = neuron_representer.instantiate()
					offset = Vector2(60, 0)
				"SynapticWeight":
					nd = weight_representer.instantiate()
					offset = Vector2(0, 0)
			if nd is GraphNode:
				nd.name = node.name
				nd.position = node.position_offset * Vector2(0.5,0.7) + offset - visible_center
				telemetryGraphEditRef.get_child(0).add_child(nd)
				for connection in all_connections:
						if connection["from_node"] == node.name:
							print(connection)
							$Panel/ScrollContainer/MarginContainer/VBoxContainer/TelemetryGraphEdit.connect_node(connection["from_node"], 0, connection["to_node"], 0)
