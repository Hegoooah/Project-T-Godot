extends CharacterBasic

func sub_ready():
	speed = 3.25
	skill_q = FioraQ.new()
	skill_r = FioraR.new()
	
func sub_physics_process(_delta):
	pass

func animation():
	var next_anim_state = animator.cur_anim_state
	if attacking:
		next_anim_state = animator.ATTACK
	elif velocity == Vector3.ZERO:
		next_anim_state = animator.IDLE
	elif velocity.length() <= 5:
		next_anim_state = animator.WALK
	elif velocity.length() > 5:
		next_anim_state = animator.RUN
	
	if next_anim_state != animator.cur_anim_state:
		animator.cur_anim_state = next_anim_state
		
func auto_attack():
	pass
