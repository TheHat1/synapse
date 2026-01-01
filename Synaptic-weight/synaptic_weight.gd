extends GraphNode

var I_main = 0.0
@onready var weight = $LineEdit.text.to_float()
var type: String = "SynapticWeight"

func _ready():
	set_slot(0, true, 2, Color.BLUE_VIOLET, true, 0, Color.GOLDENROD)
	set_slot(1, true, 1, Color.DARK_CYAN, false, 0, Color.GOLDENROD)
	
	clamp(weight, 0, 1)
	
	name = name.replace("@", "_")

func execute_input(port: int, _weight: float):
	if port == 0:
		get_parent().trigger_from(name, 0, I_main * weight)

func _on_line_edit_text_submitted(new_text: String) -> void:
	weight = new_text.to_float()

func _on_value_changed(value):
	I_main = value

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").weight_deleted += 1
		queue_free()
