# cell.gd
extends Node2D

@export var coords: Vector2i
var is_active: bool = false
var is_visited: bool = false

func set_active(active: bool):
	is_active = active
	update_appearance()

func set_visited(visited: bool):
	is_visited = visited
	update_appearance()

func update_appearance():
	if is_active:
		$MeshInstance2D.modulate = Color.YELLOW
	elif is_visited:
		$MeshInstance2D.modulate = Color(0.8, 0.8, 0.2, 1.0)
	else:
		$MeshInstance2D.modulate = Color.WHITE
