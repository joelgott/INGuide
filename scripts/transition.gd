extends Control

var text = ""
var next_scene = "res://game.tscn"

@onready var label = $MarginContainer/RichTextLabel

func _ready():
	label.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_button_pressed():
	get_tree().change_scene_to_file(next_scene)
	get_tree().get_root().remove_child($".")
