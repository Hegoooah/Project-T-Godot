extends CharacterBasic

@export var total_health := 800
@export var total_mana := 300
@export var health_regen := 1	# every 1000ms
@export var mana_regen := 1		# every 1000ms

@export var attack_damage := 70
@export var ability_power := 0
@export var armor := 30
@export var magic_resist := 30
@export var attack_speed := 0.5
@export var speed := 4
@export var critic_rate := 0		# percentage
@export var critic_damage_rate := 1.5

@export var attack_range := 4
@export var armor_pen := 0
@export var magic_pen := 0

func sub_ready():
	att_full_time = 450
	
	base_stats = CharacterStats.new()
	base_stats.copyFrom(self)
	
	skill_q = FioraQ.new()
	skill_q.register(self)
	skill_r = FioraR.new()
	skill_r.register(self)
	
func sub_physics_process(_delta):
	pass

func animation():
	var next_anim_state = animator.cur_anim_state
	if attacking:
		next_anim_state = animator.AnimationStatus.ATTACK
	elif velocity == Vector3.ZERO:
		next_anim_state = animator.AnimationStatus.IDLE
	elif (velocity.x + velocity.z) < 5:
		next_anim_state = animator.AnimationStatus.WALK
	elif (velocity.x + velocity.z) >= 5:
		next_anim_state = animator.AnimationStatus.RUN
	
	if next_anim_state != animator.cur_anim_state:
		animator.cur_anim_state = next_anim_state
		
