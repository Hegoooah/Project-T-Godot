extends CharacterBody3D

@onready var nav_agent := $NavigationAgent3D

@export var speed = 20
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _process(delta):
	if(nav_agent.is_navigation_finished()):
		return
	moveToPoint(delta, speed)

func moveToPoint(delta, speed):
	var cur_position = global_transform.origin
	var target_position = nav_agent.get_next_path_position()
	var face_direction = (cur_position - target_position).normalized()
	look_at(global_position + face_direction, Vector3.UP)
	var direction = global_position.direction_to(target_position)
	velocity = direction * speed
	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("RightMouse"):
		var camera = get_tree().get_nodes_in_group("Camera")[0]
		var mouse_position = get_viewport().get_mouse_position()
		var ray_length = 150
		var from = camera.project_ray_origin(mouse_position)
		var to = from + camera.project_ray_normal(mouse_position) * ray_length
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		var result = space.intersect_ray(ray_query)
		print(result)
		nav_agent.target_position = result.position
