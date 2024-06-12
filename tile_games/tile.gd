extends Control

@export var is_numeric = false 
@export var is_alfanumeric = false 

@export var ignoreifnotvalid = false
@export var validchars = [] 

@onready var lineedit = $LineEdit

@onready var value = lineedit.text
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_line_edit_text_changed(new_text):
	lineedit.release_focus()
	if (is_numeric and new_text.is_valid_int()) or (is_alfanumeric and new_text.is_valid_identifier()):
		lineedit.text = new_text
		value = new_text
	else:
		lineedit.text = ""
		
