extends Control

@export var word = "hola"

var grid = preload("res://tile_games/grid.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var word_grid = grid.instantiate()
	word_grid.cols = len(word)
	word_grid.rows = 1
	word_grid.is_numeric = true
	word_grid.is_alfanumeric = true
	word_grid.grid_values = []
	for char in word:
		word_grid.grid_values.append(char)
	add_child(word_grid)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
