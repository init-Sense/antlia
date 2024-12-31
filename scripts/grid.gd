extends Node2D

@export_group("Grid Elements")
@export var cell_mesh: MeshInstance2D = MeshInstance2D.new()
@export var current_note: MeshInstance2D = MeshInstance2D.new()

@export_group("Grid Properties")
@export var grid_rows: int = 5
@export var grid_cols: int = 5
@export var default_spacing: float = 30.0

var grid: Dictionary = {}
var current_position: Vector2i = Vector2i.ZERO
var links: Array[Vector2i] = []
var current_cell_instance: MeshInstance2D
var path_line: Line2D

const DIRECTIONS = {
	"up": Vector2i(-1, -1),
	"up_right": Vector2i(0, -1),
	"right": Vector2i(1, -1),
	"down_right": Vector2i(1, 0),
	"down": Vector2i(1, 1),
	"down_left": Vector2i(0, 1),
	"left": Vector2i(-1, 1),
	"up_left": Vector2i(-1, 0)
}

func _ready():
	generate_grid()
	setup_path_line()
	
	current_cell_instance = current_note.duplicate()
	grid[Vector2i.ZERO].add_child(current_cell_instance)
	current_cell_instance.visible = true
	current_cell_instance.position = Vector2.ZERO
	
	links.append(Vector2i.ZERO)
	update_path()

func setup_path_line():
	path_line = Line2D.new()
	path_line.width = 2.0
	path_line.default_color = Color.WHITE
	add_child(path_line)

func _process(_delta):
	for direction in DIRECTIONS.keys():
		if Input.is_action_just_pressed(direction):
			move_note(DIRECTIONS[direction])

func move_note(direction: Vector2i):
	var target_pos = current_position + direction
	
	if grid.has(target_pos):
		if current_cell_instance:
			current_cell_instance.get_parent().remove_child(current_cell_instance)
		
		current_position = target_pos
		grid[target_pos].add_child(current_cell_instance)
		links.append(target_pos)
		update_path()

func update_path():
	var points = []
	for link_pos in links:
		var local_pos = Vector2(link_pos) * default_spacing
		points.append(local_pos)
	path_line.points = PackedVector2Array(points)

func generate_grid():
	var offset = Vector2(grid_cols / 2, grid_rows / 2)
	
	for y in range(grid_rows):
		for x in range(grid_cols):
			var cell = cell_mesh.duplicate()
			add_child(cell)
			cell.visible = true
			
			var pos = Vector2(x - offset.x, y - offset.y)
			cell.position = pos * default_spacing
			grid[Vector2i(x - offset.x, y - offset.y)] = cell

	if !cell_mesh.mesh:
		print("Warning: No mesh assigned to cell_mesh template")
