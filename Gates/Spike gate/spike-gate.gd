extends GraphNode

var led_off = load("res://Assets/neuron_led.png")
var led_on = load("res://Assets/neuron_led_lit.png")

var is_gate_open = false

func _ready():
	set_slot(0, true, 2, Color.BLUE_VIOLET, false, 0, Color.GOLDENROD)
	set_slot(1, false, 3, Color.DIM_GRAY, true, 2, Color.BLUE_VIOLET)
	set_slot(2, true, 3, Color.DIM_GRAY, false, 0, Color.GOLDENROD)

func execute_input(port: int, _weight: float):
	if port == 0 and is_gate_open:
		get_parent().trigger_from(name, 0, 0)

func _on_gate_status_change(status: bool):
	is_gate_open = status
	if status:
		$Control3/Sprite2D.texture = led_on
	else :
		$Control3/Sprite2D.texture = led_off

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		#get_parent().get_parent().get_parent().get_node("MainMenu").neuron_deleted += 1
		queue_free()
