extends Panel

var tween: Tween
var show_panel: bool = false
var elapsed: float

func _ready() -> void:
	set_position(Vector2(get_viewport().get_visible_rect().size.x, 100.0))
	z_index = 50

func _process(delta: float) -> void:
	if show_panel:
		elapsed += delta
		$VBoxContainer/ProgressBar.value = remap(3.0 - elapsed, 0.0, 3.0, 0.0, 100.0)
		if elapsed >= 3.0:
			show_panel = false
			elapsed = 0.0
			show_panel_func()

func show_error(promt: String):
	if !show_panel:
		$VBoxContainer/MarginContainer/HBoxContainer/Label.text = promt
		show_panel = true
		show_panel_func()

func show_panel_func():
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	var target_x : float
	
	if show_panel:
		target_x = get_viewport().get_visible_rect().size.x - size.x - 25.0
	else:
		target_x = get_viewport().get_visible_rect().size.x
	
	tween.tween_property(self,"position",Vector2(target_x,100.0),0.25)
