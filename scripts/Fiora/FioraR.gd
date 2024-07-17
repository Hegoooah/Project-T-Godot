extends BaseSkill

class_name FioraR

var attack_num = 5
var remain_att_num = 0
var anim_dist = 3
var max_attack_anim_duration = 580
var attack_anim_duration = 0

var anim_timer = 0
var pos_x = [-1, -1, 1, 2, -1, 1, 2, -1, 1, 2, -2, -1]
var pos_z = [-1, 1, -1, 1, 2, -2, 1, -2, 1, -1, 1, -2]
var start_index = 0

func _init():
	cd = 1 * 1000 # in ms
	
func cast(res):
	if !isReady():
		return self.Skill_Status.SKILL_NOT_READY
	if !isTargetValid(res):
		return self.Skill_Status.INVALID_TARGET
	prepare(res)
	return self.Skill_Status.SKILL_CAST_SUCCESS

func isTargetValid(target):
	if target.collider.is_in_group("Enemy"):
		return true
	return false

func prepare(mouse_pos):
	targets = mouse_pos.collider
	
	attack_anim_duration = min(caster.att_dam_time + 280, max_attack_anim_duration)
	remain_att_num = attack_num
	caster.can_move = false
	caster.can_cast = false
	caster.can_change_move_state = false
	caster.attacking = false
	casting = true
	caster.can_change_anim_state = false
	caster.animator.cur_anim_state = caster.animator.AnimationStatus.IDLE
	start_index = randi_range(attack_num, 11)

func finish():
	caster.can_move = true
	casting = false
	caster.can_cast = true
	caster.animator.cur_anim_state = caster.animator.AnimationStatus.IDLE
	caster.can_change_anim_state = true
	caster.can_change_move_state = true
	next_avl_time = Time.get_ticks_msec() + cd
	anim_timer = 0

func process(_delta):
	if !casting:
		return
	
	if anim_timer <= 0 :
		if caster.animator.cur_anim_state == caster.animator.AnimationStatus.ATTACK:
			caster.animator.cur_anim_state = caster.animator.AnimationStatus.IDLE
			return
		if remain_att_num > 0:
			anim_timer = attack_anim_duration
			caster.animator.cur_anim_state = caster.animator.AnimationStatus.ATTACK
			remain_att_num -= 1
			
			# compute a random position near the target and teleport the caste to it
			var random_dir = Vector3(pos_x[start_index], 0, pos_z[start_index]).normalized()
			caster.position = targets.position + random_dir * anim_dist * randf_range(0.3, 1.2)
			start_index -= 1
			 
			# make the caster face the target to perform attack animation
			var face_dir = caster.position.direction_to(targets.position)
			caster.rotation.y = atan2(-face_dir.x, -face_dir.z)
			
			# TODO deal damage here
		else:
			# have cast all the attack
			finish()
	else:
		anim_timer -= _delta * 1000
