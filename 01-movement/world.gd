extends TileMap

@onready var astar_node = AStar2D.new()

var ussed_cell_cords_map = {}

func _ready():
	var cells = get_used_cells(0)
		
	for index in range(cells.size()):
		var cell = cells[index]
		ussed_cell_cords_map[cell] = index
		astar_node.add_point(index, cell)
	
	for cell in cells:
		astar_connect_walkable_cell(cell)

func astar_connect_walkable_cell(cell):
	var index = get_cell_index(cell)
	
	var cells_relative = PackedVector2Array([
		cell + Vector2i.RIGHT,
		cell + Vector2i.LEFT,
		cell + Vector2i.UP,
		cell + Vector2i.DOWN,
	])
	for cell_relative in cells_relative:
		var cell_relative_index = get_cell_index(cell_relative)
		
		if not astar_node.has_point(cell_relative_index):
			continue
		
		astar_node.connect_points(index, cell_relative_index, true)
	
	var diagonals = [
		{
			"move": cell + Vector2i.RIGHT + Vector2i.UP,
			"check": [
				cell + Vector2i.RIGHT,
				cell + Vector2i.UP,
			]
		},
		{
			"move": cell + Vector2i.LEFT + Vector2i.UP,
			"check": [
				cell + Vector2i.LEFT,
				cell + Vector2i.UP,
			]
		},
		{
			"move": cell + Vector2i.RIGHT + Vector2i.DOWN,
			"check": [
				cell + Vector2i.RIGHT,
				cell + Vector2i.DOWN,
			]
		},
		{
			"move": cell + Vector2i.LEFT + Vector2i.DOWN,
			"check": [
				cell + Vector2i.LEFT,
				cell + Vector2i.DOWN,
			]
		},
	]
	for diagonal in diagonals:
		var cell_relative_index = get_cell_index(diagonal["move"])
		
		var check = func(accum, cell):
			var cell_index = get_cell_index(cell)
			return accum and astar_node.has_point(cell_index)
			
		if not diagonal["check"].reduce(check, true):
			continue
		
		astar_node.connect_points(index, cell_relative_index, true)

func get_cell_index(cell: Vector2i) -> int:
	if ussed_cell_cords_map.has(cell):
		return ussed_cell_cords_map[cell]
	return -1

func make_path(from_local_position, to_local_position):
	var from_index = get_cell_index(local_to_map(from_local_position))
	var to_index = get_cell_index(local_to_map(to_local_position))
	
	var path = astar_node.get_point_path(from_index, to_index)
	show_path(path)
	return Array(path).map(func(cell): return to_global(map_to_local(cell)))

# debuging

@export var enable_debug = false
@onready var debug_line = $DebugLine2D

func show_path(path):
	if not enable_debug:
		return
	debug_line.clear_points()
	for point in path:
		var debug_point = to_global(map_to_local(point))
		debug_line.add_point(debug_point)
