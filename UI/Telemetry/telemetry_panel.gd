extends Control

var fadeTime: float = 500.0
var activationsPerSecond: int
var elapsed: = 0.0

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
