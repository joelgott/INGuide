extends Control

var text = ""
var next_scene = "res://game.tscn"

@onready var label = $MarginContainer/RichTextLabel

func _ready():
	if text != "":
		label.text = text

func _on_play_button_pressed():
	get_tree().change_scene_to_file(next_scene)
	get_tree().get_root().remove_child($".")
