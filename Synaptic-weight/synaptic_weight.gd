extends GraphNode

@onready var weight = $HBoxContainer/LineEdit.text.to_float() / 1000.0
var type: String = "SynapticWeight"

signal emit_spike()

func _ready():
	set_slot(0, true, 2, Color.BLUE_VIOLET, true, 0, Color.GOLDENROD)
	
	name = name.replace("@", "_")

func execute_input(port: int, _weight: float):
	if port == 0:
		get_parent().trigger_from(name, 0, weight)
		emit_signal("emit_spike")

func _on_line_edit_text_submitted(new_text: String) -> void:
	weight = new_text.to_float() / 1000.0

func _input(event):
	if event is InputEventKey and event.keycode == KEY_DELETE and event.pressed and is_selected():
		get_parent().get_parent().get_parent().get_node("MainMenu").weight_deleted += 1
		queue_free()

func update_weight(val: float):
	weight = weight + val
	$HBoxContainer/LineEdit.text = str(snappedf(weight, 0.01))

func set_weight(val:float):
	weight = val
	$HBoxContainer/LineEdit.text = str(val * 1000)
