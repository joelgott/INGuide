extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()



func _on_text_submitted(new_text):
	clear() 
