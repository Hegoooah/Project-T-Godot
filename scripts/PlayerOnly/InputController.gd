extends Node

@onready var camera = get_tree().get_nodes_in_group("Camera")[0]

var player = null

func _ready():
	player = get_parent()

func _input(_event):
	if Input.is_action_just_pressed("RightMouse"):
		var result = getMousePos()
		
		var nav_pos = Vector3.ZERO
		if result.collider.is_in_group("Enemy"):
			player.target_enemy = result.collider
			nav_pos = player.target_enemy.position
		else:
			player.destination = result.position
			player.target_enemy = null
			nav_pos = player.destination
		player.nav_agent.target_position = nav_pos
		if player.can_change_move_state:
			player.can_move = true
			player.attacking = false
			player.animator.cur_anim_state = player.animator.AnimationStatus.WALK
			# if we use move to cancel attack, reset attack timer
			if !player.attack_damaged:
				player.next_aval_att_time = 0
	if Input.is_key_pressed(KEY_Q):
		var result = getMousePos()
		player.skill_q.cast(result)
		
	if Input.is_key_pressed(KEY_R):
		var result = getMousePos()
		player.skill_r.cast(result)

func getMousePos():
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 150
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_length
	var space = player.get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	return space.intersect_ray(ray_query)
