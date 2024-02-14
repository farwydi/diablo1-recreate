extends Node2D

@onready var tile_map = $TileMap
@onready var player = $Player

func _ready():
	tile_map.enable_debug = true

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			on_mouse_left_pressed(event)

func on_mouse_left_pressed(event):
	var to = tile_map.get_local_mouse_position()
	var from = tile_map.to_local(player.global_position)
	
	player.target_path = tile_map.make_path(from, to)
