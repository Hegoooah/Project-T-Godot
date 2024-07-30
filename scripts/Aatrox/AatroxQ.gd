extends BaseSkill

class_name AatroxQ

var next_q_phase = 0
var dir

var cast_time = [800, 933, 766]
var damage_out_time = [750, 800, 700]
var cd_between_phase = 700

var anim_play_time = 0
var post_anim_time = 0
var post_process = false
var dealt_damage = false
var indicator = null

func _init():
	cd = 3 * 1000 # in ms
	icon = preload("res://assets/Aatrox/HUD/aatrox_q.dds")
	
func cast(dest):
	if !isReady():
		return self.Skill_Status.SKILL_NOT_READY
	# no need to check target valid or not
	prepare(dest)
	return self.Skill_Status.SKILL_CAST_SUCCESS

func prepare(mouse_pos):
	var dest = mouse_pos.position
	dest.y = 0
	
	dir = caster.position.direction_to(dest)

	caster.rotation.y = atan2(-dir.x, -dir.z)
	caster.can_move = false
	caster.can_change_move_state = false
	caster.attacking = false
	casting = true
	caster.can_change_anim_state = false
	caster.animator.hardChangeState(caster.animator.AnimationStatus.CAST_Q_1 + next_q_phase)
	anim_play_time = 0
	post_anim_time = 0
	post_process = false
	dealt_damage = false
	if next_q_phase == 0:
		indicator = caster.q1_indicator
	elif next_q_phase == 1:
		indicator = caster.q2_indicator
	elif next_q_phase == 2:
		indicator = caster.q3_indicator
	indicator.visible = true

func finish():
	indicator.visible = false
	caster.can_move = true
	casting = false
	if caster.nav_agent.is_navigation_finished():
		# no move command go to idle
		caster.animator.hardChangeState(caster.animator.AnimationStatus.CAST_Q_1_TO_IDLE + next_q_phase)
	else:
		caster.animator.hardChangeState(caster.animator.AnimationStatus.CAST_Q_1_TO_WALK + next_q_phase)
		
	if next_q_phase == 2:
		# all q phase down
		next_avl_time = Time.get_ticks_msec() + cd
		next_q_phase = 0
	else:
		# set cast phase to next one and give it a small cd
		next_q_phase += 1
		next_avl_time = Time.get_ticks_msec() + cd_between_phase
		
	post_process = true
	

func postAnimProcess():
	post_process = false
	caster.can_change_anim_state = true
	caster.can_change_move_state = true

func process(_delta):
	if post_process:
		post_anim_time += _delta * 1000
		if post_anim_time > 500:
			postAnimProcess()
	
	if !casting:
		return
	
	anim_play_time += _delta * 1000
	if anim_play_time > cast_time[next_q_phase]:
		finish()
	elif anim_play_time > damage_out_time[next_q_phase] and not dealt_damage:
		dealDamage()
		
func dealDamage():
	dealt_damage = true
	var space_state = caster.get_world_3d().direct_space_state
	var area_inner = null
	var area_outer = null
	if next_q_phase == 0:
		area_inner = caster.q1_area_inner
		area_outer = caster.q1_area_outer
	elif next_q_phase == 1:
		area_inner = caster.q2_area_inner
		area_outer = caster.q2_area_outer
	else:
		area_inner = caster.q3_area_inner
		area_outer = caster.q3_area_outer
	
	# compute damage for outer area
	var query_params = PhysicsShapeQueryParameters3D.new()
	query_params.transform = area_outer.global_transform
	query_params.shape_rid = area_outer.get_shape().get_rid()
	query_params.collision_mask = 1
	var results = space_state.intersect_shape(query_params)
	
	var damage = DamageCompute.new()
	damage.init(caster.final_stats.attack_damage * (1.2 + next_q_phase * 0.4), 0, 0, DamageCompute.DamageType.SPELL, caster)

	# record the enemy being damaged by outer area
	var outer_damaged_enemy = {}
	for result in results:
		var enemy = result.collider
		if enemy.is_in_group(caster.hostile_group):
			var knock_up_buff = KnockUpBuff.new()
			knock_up_buff.init(200, caster, enemy)
			
			damage.buff_to_enemy[knock_up_buff.buff_id] = knock_up_buff
			
			damage.compute_theory_damage(enemy)
			damage.apply_damage(enemy)
			outer_damaged_enemy[enemy] = 1
			
	
	# compute damage for inner area
	query_params.transform = area_inner.global_transform
	query_params.shape_rid = area_inner.get_shape().get_rid()
	results = space_state.intersect_shape(query_params)
	
	var damage_inner = DamageCompute.new()
	damage_inner.init(caster.final_stats.attack_damage * (0.8 + next_q_phase * 0.2), 0, 0, DamageCompute.DamageType.SPELL, caster)

	for result in results:
		var enemy = result.collider
		if enemy.is_in_group(caster.hostile_group) and !outer_damaged_enemy.has(enemy):
			damage_inner.compute_theory_damage(enemy)
			damage_inner.apply_damage(enemy)

	
