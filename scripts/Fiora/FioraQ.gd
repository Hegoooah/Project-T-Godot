extends BaseSkill

class_name FioraQ

var max_move_dist = 3.0		# unit meter
var move_dist = 0
var move_speed = 14.0		# unit meter per second
var dir = null
var move_time = 0	# 

func _init():
	cd = 1 * 1000 # in ms
	
func cast(source, dest):
	if !isReady():
		return self.SKILL_NOT_READY
	# no need to check target valid or not
	prepare(source, dest)
	return self.SKILL_CAST_SUCCESS

func prepare(source, mouse_pos):
	var dest = mouse_pos.position
	caster = source
	dir = caster.position.direction_to(dest)
	move_dist = min(caster.position.distance_to(dest), max_move_dist)
	move_time = move_dist / move_speed
	caster.rotation.y = atan2(-dir.x, -dir.z)
	caster.can_move = false
	caster.can_change_move_state = false
	caster.attacking = false
	casting = true
	caster.can_change_anim_state = false
	caster.animator.cur_anim_state = caster.animator.CAST_Q

func finish():
	# TODO deal damage at the end point
	caster.can_move = true
	casting = false
	caster.animator.cur_anim_state = caster.animator.IDLE
	caster.can_change_anim_state = true
	caster.can_change_move_state = true
	next_avl_time = Time.get_ticks_msec() + cd

func process(_delta):
	if !casting:
		return
	caster.position = caster.position + dir * move_speed * _delta
	move_time -= _delta
	if move_time <= 0:
		finish()
