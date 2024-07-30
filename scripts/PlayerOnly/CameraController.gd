extends Node3D

# Speed at which the camera moves
@export var move_speed := 20.0
# Margin in pixels within which the camera starts moving when the mouse is near the edge
@export var edge_margin := 50

# the unit is grid not pixels
@export var boundary_left := -20.0
@export var boundary_right := 20.0
@export var boundary_top := -20.0
@export var boundary_bottom := 20.0

var player
var screen_size

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	screen_size = get_viewport().size
	get_viewport().connect("size_changed", _on_screen_resized)
	
func _process(delta):
	moveCamera(delta)

func moveCamera(delta):
	var mouse_position = get_viewport().get_mouse_position()

	var direction := Vector3.ZERO

	if mouse_position.x <= edge_margin:
		direction.x -= 1
	elif mouse_position.x >= screen_size.x - edge_margin:
		direction.x += 1

	if mouse_position.y <= edge_margin:
		direction.z -= 1
	elif mouse_position.y >= screen_size.y - edge_margin:
		direction.z += 1

	var new_position = position + direction.normalized() * move_speed * delta

	# Clamp the new position within the boundaries
	new_position.z = clamp(new_position.z, boundary_left, boundary_right)
	new_position.x = clamp(new_position.x, boundary_top, boundary_bottom)

	position = new_position
	
func _on_screen_resized():
	screen_size = get_viewport().size
