#grid.gd
extends Node

#region grid
# where we start
@onready var root_cell: Vector2i
# the current active cell
@onready var current_cell: Vector2i = root_cell
# the grid that needs to be generated from the cells
var grid: Array[Vector2i]
# the link between two cells
var links: Array[Vector2i]
# the puzzle solution
@export var solution: Array[Vector2i]
@export var links_limit: int

func _ready():
	print_tree_pretty()
	pass
	#for each cell in grid: 
	# build matrix and compute boundaries from center

func link(element0: Vector2, element1: Vector2):
	pass
	# check if distance is no more than one

	# check if computation exceeds boundaries (i.e.: matrix is 5x5 and boundaries are [-2,2]) 

	# at the end, check if the player_attempt array is equal to the solution array
	if links == solution:
		pass
	else:
		reset()

func reset():
	# reset state
	pass
#endregion
