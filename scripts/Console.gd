extends RichTextLabel

var text_speed = 0.02
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func print_text(new_text):
	for chararacter in new_text:
		self.text += chararacter
		await get_tree().create_timer(text_speed).timeout

func clear_text():
	self.text = ""
