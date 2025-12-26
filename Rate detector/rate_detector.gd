extends GraphNode

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")
@export var type: String = "RateDetector"

var rate = 0.0
var target_hz = 1.0
var output_on = false

func _ready():
	set_slot(0, true, 2, Color.BLUE_VIOLET, false, 0, Color.GOLDENROD)

func execute_input(port: int, _weight: float):
	if port == 0:
		rate += 1.0

func _process(delta):
	rate -= rate * delta
	rate = max(rate, 0.0)
	output_on = rate >= target_hz
	if output_on:
		$HBoxContainer/Control/Sprite2D.texture = led_on
	else :
		$HBoxContainer/Control/Sprite2D.texture = led_off

func _on_line_edit_text_submitted(new_text: String) -> void:
	target_hz = new_text.to_float()

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_node("MainMenu").rate_detector_deleted += 1
		queue_free()
