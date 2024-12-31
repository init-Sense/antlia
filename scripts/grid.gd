extends Node2D

@export_group("Grid Elements")
@export var cell_mesh: MeshInstance2D = MeshInstance2D.new()
@export var current_note: MeshInstance2D = MeshInstance2D.new()
@export var start_point_mesh: MeshInstance2D = MeshInstance2D.new()

@export_group("Grid Properties")
@export var default_spacing: float = 30.0
@export var grid_size: int = 2
@export var core_size: int = 1

var grid: Dictionary = {}
var current_position: Vector2i = Vector2i.ZERO
var grid_center: Vector2i = Vector2i.ZERO
var links: Array[Vector2i] = []
var current_cell_instance: MeshInstance2D
var start_point_instance: MeshInstance2D
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
	setup_start_and_current_note()

func setup_path_line():
	path_line = Line2D.new()
	path_line.width = 2.0
	path_line.default_color = Color.WHITE
	add_child(path_line)

func setup_start_and_current_note():
	start_point_instance = start_point_mesh.duplicate()
	grid[Vector2i.ZERO].add_child(start_point_instance)
	start_point_instance.visible = true
	
	current_cell_instance = current_note.duplicate()
	grid[Vector2i.ZERO].add_child(current_cell_instance)
	current_cell_instance.visible = true
	
	links.append(Vector2i.ZERO)
	update_path()

func _process(_delta):
	for direction in DIRECTIONS.keys():
		if Input.is_action_just_pressed(direction):
			move_note(DIRECTIONS[direction])

func is_within_core(pos: Vector2i) -> bool:
	return abs(pos.x - grid_center.x) <= core_size and abs(pos.y - grid_center.y) <= core_size

func update_path():
	var points = []
	for link_pos in links:
		var local_pos = Vector2(link_pos) * default_spacing
		points.append(local_pos)
	path_line.points = PackedVector2Array(points)

func generate_grid(center: Vector2i = Vector2i.ZERO):
	var cells_to_keep = links.duplicate()
	for pos in grid.keys():
		if !cells_to_keep.has(pos):
			grid[pos].queue_free()
			grid.erase(pos)
	
	for y in range(-grid_size, grid_size + 1):
		for x in range(-grid_size, grid_size + 1):
			var pos = Vector2i(x, y) + center
			if !grid.has(pos):
				create_cell(pos)
				var distance_from_core = max(
					max(0, abs(x) - core_size),
					max(0, abs(y) - core_size)
				)
				if distance_from_core > 0:
					var alpha = 1.0 - (float(distance_from_core) / (grid_size - core_size))
					alpha = clampf(alpha, 0.2, 0.9)
					grid[pos].modulate.a = alpha

func create_cell(pos: Vector2i):
	var cell = cell_mesh.duplicate()
	add_child(cell)
	cell.visible = true
	cell.position = Vector2(pos) * default_spacing
	grid[pos] = cell

func move_note(direction: Vector2i):
	var target_pos = current_position + direction
	
	if !is_within_core(target_pos):
		grid_center += direction
		generate_grid(grid_center)
	
	if current_cell_instance:
		current_cell_instance.get_parent().remove_child(current_cell_instance)
	
	current_position = target_pos
	grid[target_pos].add_child(current_cell_instance)
	links.append(target_pos)
	update_path()
