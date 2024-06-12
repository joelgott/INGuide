extends Node2D

var globalangle = 0
const x_offset = 1

var max_points = 350

var available_freqs 
var available_orders
var available_radius
var available_ws

var rand_freq = 1
var rand_order = 1
var rand_radius = 1
var rand_ws = "square"

@onready var order_slider = $"../../GUI/sliders/order/order slider"
@onready var freq_slider = $"../../GUI/sliders/freq/freq slider"
@onready var radius_slider = $"../../GUI/sliders/radius/radius slider"
@onready var return_button = $"../../GUI/sliders/return"

@onready var epiorder = order_slider.value
@onready var freq = freq_slider.value
@onready var radius = radius_slider.value
@onready var waveshape = "square"

# Called when the node enters the scene tree for the first time.
func _ready():
	available_freqs = get_range(freq_slider)
	available_orders = get_range(order_slider)
	available_radius = get_range(radius_slider)
	available_ws = ["square","triangular","sawtooth","pulse"]
	shuffle_vars()

func get_range(obj):
	return range(obj.min_value,obj.max_value,obj.step)

func shuffle_vars():
	rand_freq = available_freqs[randi() % available_freqs.size()]
	rand_order = available_orders[randi() % available_orders.size()]
	rand_radius = available_radius[randi() % available_radius.size()]
	rand_ws = available_ws[randi() % available_ws.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	globalangle += freq * delta
	# We only wrap angles when both of them are bigger than 360.
	#if angle > 360:
	#	angle = wrapf(angle, 0, 360)

	queue_redraw()

func _draw_circle(center, _radius, color):
	draw_arc( center,_radius, 0, 2*PI,100, color ,3)
	
func draw_epicycles(center,angle,_radius,order,ws,color):
	var x = center.x
	var y = center.y
	for i in range(order):
		var prev_x = x
		var prev_y = y
		var n = i * 2 + 1
		var z = calc_values(_radius,i,angle,ws,order)
		x += z[0]
		y += z[1]
		var epiradius = sqrt(pow(z[0],2)+pow(z[1],2))
		_draw_circle( Vector2(prev_x,prev_y), epiradius, color)
		draw_line(Vector2(prev_x,prev_y),Vector2(x,y),color,3)
	return Vector2(x,y)

func calc_values(amplitude,i,angle,ws,order):
	match ws:
		"square":
			var n = 2*i+1
			return [amplitude*(4 / (n * PI))*cos(n * angle), amplitude*(4 / (n * PI))*sin(n * angle)]
		"triangular":
			var n = 2*i+1
			return [amplitude*(8 / pow(n * PI,2))*pow(-1,i)*cos(n * angle), amplitude*(8 / pow(n * PI,2))*pow(-1,i)*sin(n * angle)]
		"sawtooth":
			var n = i + 1
			return [amplitude*(2 / (n * PI))*cos(n * angle), amplitude*(2 / (n * PI))*sin(n * angle)]
		"pulse":
			var n = i + 1
			return [-amplitude/order*sin(n * angle), -amplitude/order*cos(n * angle)]
	
func draw_wave(draw_offset, n_points,starting_angle, order, freq, radius, ws, color):
	var wave = []
	for i in range(n_points):
		var x = 0
		var y = 0 
		var angle = i*freq*2*PI/(n_points)+starting_angle
		for j in range(order):
			var z = calc_values(radius,j,angle,ws,order)
			x += z[0]
			y += z[1]
			var epiradius = sqrt(pow(z[0],2)+pow(z[1],2))
		wave.append(Vector2(i+draw_offset,y))
	draw_polyline(wave,color,5)
	
	
func _draw():
	var color
	draw_wave(200,max_points,0,rand_order,rand_freq,rand_radius,rand_ws, Color.BLACK)
	if (freq == rand_freq and epiorder == rand_order and radius == rand_radius and waveshape == rand_ws):
		color = Color(0,1,0)
		return_button.disabled = false
	else:
		color = Color(1,0,0)
		return_button.disabled = true
	var z = draw_epicycles(Vector2(0,0),globalangle, radius, epiorder, waveshape, color)
	draw_wave(200,max_points,globalangle,epiorder,freq,radius,waveshape, color)
	draw_line(z, Vector2(200,z.y),color,3)


func _on_radius_slider_value_changed(value):
	radius = floor(value) 

func _on_freq_slider_value_changed(value):
	freq = floor(value)	

func _on_order_slider_value_changed(value):
	epiorder = floor(value)


func _on_wave_select_item_selected(index):
	match index:
		0:waveshape = "square"
		1:waveshape = "triangular"
		2:waveshape = "sawtooth"
		3:waveshape = "pulse"

func _on_button_pressed():
	shuffle_vars()
