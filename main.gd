extends Control

var menu_open = true
var tween: Tween
var main_menu = load("res://UI/main_menu.tscn").instantiate()

func _ready() -> void:
	add_child.call_deferred(main_menu)

func _on_texture_button_pressed() -> void:
	menu_open = !menu_open
	
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	var target_x := 0.0 if menu_open else -500.0
	tween.tween_property(main_menu,"position",Vector2(target_x,0),0.25)
