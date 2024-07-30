extends CharacterBody3D

class_name CharacterBasic

@onready var nav_agent := $NavigationAgent3D
@onready var animator := $AnimationTree
@onready var animation_player := $AnimationPlayer
@onready var health_bar := $HealthBar

var hostile_group = 'Player'
var base_stats = null
var final_stats = CharacterStats.new()
var need_recompute = false

const SMOOTH_SPEED = 30.0

var destination = Vector3()
var target_enemy = null

var can_move = true
var can_cast = true
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

var on_hit_buffs = {}	# check this whenever auto-attack hits enemy
var on_cast_hit_buffs = {}	# check this whenever spell hits enemy
var stat_buffs = {}		# recalculate character stats whenever a new buff is added or an old one is removed
var simple_timed_buffs = {}	# simply disapper when time ends, character does not need to actively check these buffs
var on_damaged_buffs = {}	# check this whenever get hit

var no_move_counter = 0
var no_cast_counter = 0

func _ready():
	sub_ready()
	
	# after all the initalize steps, compute the final stats
	computeFinalStats()
	cur_health = final_stats.total_health
	health_bar.updateBar()
	
func sub_ready():
	pass

func _process(delta):
	driveAllBuffs(delta)
	checkStats()
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
	if skill_p != null:
		skill_p.process(delta)
	if skill_q != null:
		skill_q.process(delta)
	if skill_w != null:
		skill_w.process(delta)
	if skill_e != null:
		skill_e.process(delta)
	if skill_r != null:
		skill_r.process(delta)
	
	
func checkAttack():
	if target_enemy != null && canAttack():
		# attack lunched
		can_move = false
		can_change_move_state = true
	if attacking:
		var cur_time = Time.get_ticks_msec()
		if !attack_damaged and cur_time > (cur_att_start_time + att_dam_time):
			autoAttack(target_enemy)
			
			attack_damaged = true
		if cur_time > (cur_att_start_time + att_pre_anim_time):
			can_change_move_state = false
		if attack_damaged and cur_time > (cur_att_start_time + att_full_time):
			attacking = false
			can_move = true
			can_change_move_state = true
		
# override this method when the character auto attack apply extra effects	
func autoAttack(target_enemy):
	# deal damage
	var damage = DamageCompute.new()
	damage.init(final_stats.attack_damage, 0, 0, DamageCompute.DamageType.AUTO_ATTACK, self)
	damage.can_phy_critic = true
	damage.compute_theory_damage(target_enemy)
	damage.apply_damage(target_enemy)
	
func canAttack():
	var cur_time = Time.get_ticks_msec()
	if cur_time > next_aval_att_time:
		var dis_to_enemy = global_position.distance_to(target_enemy.position)
		if dis_to_enemy < final_stats.attack_range:
			if isFaceEnemy():
				var attack_interval = 1000.0 / final_stats.attack_speed
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
	if !can_move or no_move_counter > 0:
		return
	if nav_agent.is_navigation_finished():
		# no need to move
		velocity = Vector3.ZERO
		return
	
	# as long as nav not finish, we should keep track of facing direction
	var next_position = nav_agent.get_next_path_position()
	var dis_to_pos = global_position.distance_to(next_position)
	if dis_to_pos < delta * final_stats.speed * 0.5:
		global_position = next_position
		return
	
	var new_dir = global_position.direction_to(next_position)
	if  dis_to_pos > 0.1:
		#look_at(global_position + Vector3(new_dir.x, 0, new_dir.z), Vector3.UP)
		rotation.y = lerp_angle(rotation.y, atan2(-new_dir.x, -new_dir.z), delta * SMOOTH_SPEED)
	
	if target_enemy != null and nav_agent.distance_to_target() < final_stats.attack_range:
		# have a target but within attack range, no move
		velocity = Vector3.ZERO
		return
		
	# we have a move command, either move or chase
	velocity = new_dir * final_stats.speed
	move_and_slide()
	
func takeDamage(damageObject:DamageCompute):
	for buff_id in on_damaged_buffs:
		on_damaged_buffs[buff_id].addEffect(damageObject)
	for buff_id in on_damaged_buffs:
		on_damaged_buffs[buff_id].multEffect(damageObject)
	
	cur_health = cur_health - damageObject.final_phy_damage - damageObject.final_mag_damage - damageObject.final_true_damage
	health_bar.updateBar()
	print(damageObject.final_phy_damage , "," , damageObject.final_mag_damage , "," , damageObject.final_true_damage , "," , damageObject.is_critic)
	
	# apply all the buffs resulted from this damage
	for buff_id in damageObject.buff_to_enemy:
		damageObject.buff_to_enemy[buff_id].apply()

func checkStats():
	if need_recompute:
		computeFinalStats()
		need_recompute = false

# every time a new stats buff is applied or expired, this method should be called
func computeFinalStats():
	# load the basic stats
	final_stats.copyFrom(base_stats)
	
	for buff_id in stat_buffs:
		stat_buffs[buff_id].addEffect(final_stats)
	for buff_id in stat_buffs:
		stat_buffs[buff_id].multEffect(final_stats)
	health_bar.updateBar()
		
func resetNavAgent():
	nav_agent.target_position = nav_agent.target_position

func driveAllBuffs(delta):
	for buff_id in on_hit_buffs:
		on_hit_buffs[buff_id].process(delta)
	for buff_id in on_cast_hit_buffs:
		on_cast_hit_buffs[buff_id].process(delta)
	for buff_id in on_damaged_buffs:
		on_damaged_buffs[buff_id].process(delta)
	for buff_id in simple_timed_buffs:
		simple_timed_buffs[buff_id].process(delta)
	for buff_id in stat_buffs:
		stat_buffs[buff_id].process(delta)	

func interruptAllSpell():
	pass
		
