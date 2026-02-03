extends Control

var hypercube := []
var colours = []
var steps = 10

func pass_hypercube(h,c, s):
	hypercube = h
	colours = c
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
	var br = 0
	for line in hypercube:
		var line_color = colours[br]
		br += 1
		var min_v = line.min()
		var max_v = line.max()
		for i in line.size() - 1:
			var x1 = i * size.x / (line.size() - 1)
			var x2 = (i + 1) * size.x / (line.size() - 1)
			
			var y1 = size.y * (1.0 - (line[i] - min_v) / (max_v - min_v))
			var y2 = size.y * (1.0 - (line[i + 1] - min_v) / (max_v - min_v))
			
			draw_line(Vector2(x1, y1), Vector2(x2, y2), line_color, 2.0, true)

func _ready() -> void:
	queue_redraw()
