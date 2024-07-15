extends CharacterBody3D

class_name CharacterBasic

@onready var nav_agent := $NavigationAgent3D
@onready var animator := $AnimationTree

@export var total_health = 100
@export var attack_damage = 40
@export var speed = 3
@export var attack_range = 3
@export var fall_acceleration = 75
@export var attack_speed = 0.5

const SMOOTH_SPEED = 30.0

var destination = Vector3()
var target_enemy = null

var can_move = true
var can_change_move_state = true
var can_change_anim_state = true

var cur_health = 0

var attacking = false
var attack_damaged = false
var next_aval_att_time = 0
var cur_att_start_time = 0
var att_dam_time = 280
var att_pre_anim_time = 320
var att_full_time = 650		# TODO the full attack time is related to attack animation time 

var skill_p = null
var skill_q = null
var skill_w = null
var skill_e = null
var skill_r = null

func _ready():
	cur_health = total_health
	sub_ready()
	
func sub_ready():
	pass

func _process(delta):
	checkAttack()
	checkSkill(delta)
	
	# animation is the last thing to change
	if can_change_anim_state:
		animation()
	
func animation():
	pass

func _physics_process(delta):
	moveToPoint(delta)
	sub_physics_process(delta)

func sub_physics_process(_delta):
	pass
	
func checkSkill(delta):
	check_p(delta)
	check_q(delta)
	check_w(delta)
	check_e(delta)
	check_r(delta)
	
func check_p(_delta):
	pass

func check_q(_delta):
	if skill_q == null:
		return
	skill_q.process(_delta)
	
func check_w(_delta):
	pass
	
func check_e(_delta):
	pass
	
func check_r(_delta):
	if skill_r == null:
		return
	skill_r.process(_delta)
	
func checkAttack():
	if target_enemy != null && canAttack():
		# attack lunched
		can_move = false
		can_change_move_state = true
	if attacking:
		var cur_time = Time.get_ticks_msec()
		if !attack_damaged and cur_time > (cur_att_start_time + att_dam_time):
			# deal damage
			target_enemy.takeDamage(attack_damage)
			attack_damaged = true
		if cur_time > (cur_att_start_time + att_pre_anim_time):
			can_change_move_state = false
		if attack_damaged and cur_time > (cur_att_start_time + att_full_time):
			attacking = false
			can_move = true
			can_change_move_state = true
			
	
func canAttack():
	var cur_time = Time.get_ticks_msec()
	if cur_time > next_aval_att_time:
		var dis_to_enemy = global_position.distance_to(target_enemy.position)
		if dis_to_enemy < attack_range:
			if isFaceEnemy():
				var attack_interval = 1000.0 / attack_speed
				next_aval_att_time = cur_time + attack_interval
				cur_att_start_time = cur_time
				attacking = true
				attack_damaged = false
				velocity = Vector3.ZERO
				return true
	return false
		
func isFaceEnemy():
	# require target enemy not null
	var enemy_dir = global_position.direction_to(target_enemy.position)
	var angle = abs(rotation.y - atan2(-enemy_dir.x, -enemy_dir.z))
	if angle < 0.25:	# 90 degree is around 1.5 so, 0.25 = 15 degree
		return true
	else:
		return false
	
func moveToPoint(delta):
	if !can_move:
		return
	if nav_agent.is_navigation_finished():
		# no need to move
		velocity = Vector3.ZERO
		return
	
	# as long as nav not finish, we should keep track of facing direction
	var next_position = nav_agent.get_next_path_position()
	var dis_to_pos = global_position.distance_to(next_position)
	if dis_to_pos < delta * speed * 0.5:
		global_position = next_position
		return
	
	var new_dir = global_position.direction_to(next_position)
	if  dis_to_pos > 0.1:
		#look_at(global_position + Vector3(new_dir.x, 0, new_dir.z), Vector3.UP)
		rotation.y = lerp_angle(rotation.y, atan2(-new_dir.x, -new_dir.z), delta * SMOOTH_SPEED)
	
	if target_enemy != null and nav_agent.distance_to_target() < attack_range:
		# have a target but within attack range, no move
		velocity = Vector3.ZERO
		return
		
	# we have a move command, either move or chase
	velocity = new_dir * speed
	move_and_slide()
	
func takeDamage(damage):
	cur_health -= damage
	print(damage)
