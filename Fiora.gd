extends CharacterBody3D

@onready var nav_agent := $NavigationAgent3D

@export var speed = 20
@export var fall_acceleration = 75

var destination = Vector3()
var target_enemy = null
var attack_range = 10

func _process(delta):
	if(nav_agent.is_navigation_finished()):
		velocity = Vector3.ZERO
	animation()
	moveToPoint()
	
func animation():
	$AnimationTree.set("parameters/conditions/idle", velocity == Vector3.ZERO)
	$AnimationTree.set("parameters/conditions/walk", velocity != Vector3.ZERO)

func moveToPoint():
	if target_enemy == null:
		nav_agent.target_position = destination
	else:
		nav_agent.target_position = target_enemy.position
	nav_agent.target_position = nav_agent.get_final_position()
	
	var target_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(target_pos)
	var distance = global_position.distance_to(target_pos)
	
	if (target_enemy == null):
		velocity = direction * speed
		if (global_position - target_pos).length() > 0.1:
			faceDirection(target_pos)
		move_and_slide()
	else:
		velocity = direction * speed
		if (global_position - target_pos).length() > 0.1:
			faceDirection(target_pos)
			move_and_slide()
		else:
			velocity = Vector3.ZERO
			attack()
	
func faceDirection(cur_target):
	look_at(Vector3(cur_target.x, global_position.y, cur_target.z), Vector3.UP)

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
		print("Distance: ", global_position.distance_to(result.position))
		if result.collider.is_in_group("Enemy"):
			target_enemy = result.collider
			print(target_enemy)
		else:
			destination = result.position
			target_enemy = null

func attack():
	print("Attacking ", target_enemy.name)
