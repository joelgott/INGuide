extends CharacterBody2D

var win_size : Vector2
@onready var status = $"../status"
@onready var return_button = $"../return"

const ObjSpeed = 700
const MaxSpeed = 1500
const MinSpeed = 300
var speed : int
var dir : Vector2
var restitution = 1
var objective : int
var tolerance = 0.1

func _ready():
	win_size = get_viewport_rect().size
	objective = randf_range(ObjSpeed*0.9, ObjSpeed*1.1)
	new_start()
	
	

func new_start():
	position.x = randi_range(win_size.x*0.2,win_size.x*0.8)
	position.x = randi_range(win_size.y*0.2,win_size.y*0.8)
	speed = randf_range(MaxSpeed*0.8, MaxSpeed)
	dir = random_direction()
	update_objective()

	
func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = [1, -1].pick_random()
	return new_dir.normalized()

func update_objective():
	if abs(speed - objective) < objective * tolerance:
		status.text = "El sistema se encuentra en equilibrio"
		status.add_theme_color_override("font_color", Color.CHARTREUSE)
		return_button.disabled = false
	elif (speed - objective) > objective * tolerance:
		status.text = "El sistema se encuentra en desequilibrio, hay demasiada energia!"
		status.add_theme_color_override("font_color", Color.CRIMSON)
	elif (speed - objective) < objective * -tolerance:
		status.text = "El sistema se encuentra en desequilibrio, hay muy poca energia!"
		status.add_theme_color_override("font_color", Color.CRIMSON)

func _physics_process(delta):

	var collision = move_and_collide(dir * speed * delta)
	if collision:
		dir = dir.bounce(collision.get_normal())
		speed *= restitution
		update_objective()
		if speed > MaxSpeed:
			speed = MaxSpeed
		if speed < MinSpeed:
			speed = MinSpeed
		
func _on_restart_pressed():
	new_start()

func _on_coef_slider_value_changed(value):
	restitution = value
