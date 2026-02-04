extends Control

var hypercube := []
var colours = []
var steps = 10

func pass_hypercube(h,c):
	var steps_bank = []
	var value_bank = []
	for element in h:
		for param in element:
			steps_bank.append(param[0].to_int())
			value_bank.append(param[1].to_int())
		hypercube.append([steps_bank, value_bank])
		steps_bank = []
		value_bank = []
	colours = c
	queue_redraw()

func pass_steps(s):
	steps = s
	queue_redraw()

func _draw() -> void:
	draw_line(Vector2(0,0), Vector2(0, size.y), Color.WHITE, 1.5)
	draw_line(Vector2(0,size.y), Vector2(size.x, size.y), Color.WHITE, 1.5)
	var step_x = size.x / steps
	var step_y = size.y / steps
	var crnt_x = step_x
	var crnt_y = step_y
	
	for i in range(1, steps):
		draw_line(Vector2(crnt_x,0), Vector2(crnt_x, size.y), Color.DIM_GRAY)
		draw_line(Vector2(0,crnt_y), Vector2(size.x, crnt_y), Color.DIM_GRAY, 1.5)
		crnt_x += step_x
		crnt_y += step_y
	
	if hypercube == []:
		return
	for line in hypercube:
		var min_v = line[0].min()
		var max_v = line[0].max()
		

func _ready() -> void:
	queue_redraw()
