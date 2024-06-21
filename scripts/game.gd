extends Control

@onready var console = $Background/MarginContainer/VBoxContainer/GameText/MarginContainer/Console

var commands = 	["salir","ayuda","cargar","juegos"]
var commands_help = ["Vuelve al menu principal","Da una lista de comandos disponibles.\nTambien explica que hace cada comando si se escribe ayuda [comando].","Permite cargar alguno de los juegos escribiendo cargar [juego].","Da una lista de los juegos disponibles."]

var scenes_dict = {}

func process_command(input):
	console.clear_text()
	var words = input.split(" ", false)
	if words.size() == 0:
		console.print_text("Error: no se detecto ninguna palabra.")
		return
		
	var first_word = words[0].to_lower()
	var second_word = ""
	if words.size() > 1:
		second_word = words[1].to_lower()
	
	match first_word:
		"salir":get_tree().change_scene_to_file("res://start.tscn")
		"ayuda":
			if words.size() == 1:
				var text = "Comandos disponibles: \n"
				for command in commands:
					text += "- " + command + "\n"
				console.print_text(text)
			elif words.size() == 2:
				var command = commands.find(second_word)
				if command != -1:
					var text = second_word + ": \n"
					text += commands_help[command]
					console.print_text(text)
				else:
					console.print_text("Comando desconocido, escribi ayuda para obtener una lista de comandos")
			else:
				console.print_text("Comando desconocido, escribi ayuda para obtener una lista de comandos")
		"cargar":		
			if words.size() == 1 or second_word not in scenes_dict:
				console.print_text("Juego no reconocido, escribi juegos para obtener una lista de los juegos disponibles")
			else:
				var transition_scene = load("res://transition.tscn").instantiate();
				transition_scene.text = scenes_dict[second_word]["text"]
				transition_scene.next_scene = scenes_dict[second_word]["next_scene"]
				get_tree().get_root().add_child(transition_scene)
				get_tree().get_root().remove_child($".")
		"juegos":
			var text = "Juegos disponibles: \n"
			for game in scenes_dict:
				text += "- " + scenes_dict[game]["name"] + "\n" 
			text += "Para seleccionar alguno de los juegos se debe escribir cargar [juego]"
			console.print_text(text)
		
		_: console.print_text("Comando desconocido, escribi ayuda para obtener una lista de comandos")

func _ready():
	var file = "res://games_descriptions.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	scenes_dict = JSON.parse_string(json_as_text)
	if scenes_dict:
		print(scenes_dict)
	
func _on_line_edit_text_submitted(new_text):
	process_command(new_text)


