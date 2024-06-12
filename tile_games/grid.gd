extends Control

@export var cols = 1
@export var rows = 1

@export var is_numeric = false 
@export var is_alfanumeric = false 

@export var grid_values = [] 

var tile = preload("res://tile_games/tile.tscn")
var tile_size = 60
var tiles = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(rows):
		for j in range(cols):
			var tile_ij = tile.instantiate()
			tile_ij.is_numeric = is_numeric
			tile_ij.is_alfanumeric = is_alfanumeric
			tile_ij.position = Vector2(j*tile_size, i*tile_size)
			tile_ij.scale = Vector2(float(tile_size)/80, float(tile_size)/80)
			add_child(tile_ij)
			tiles.append(tile_ij)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_win_condition()
		
func check_win_condition():
	var grid_len = len(grid_values)
	var result = 0
	for i in range(grid_len):
		if str(grid_values[i]) == str(tiles[i].value):
			result += 1
	if result == grid_len:
		print("WIN")
