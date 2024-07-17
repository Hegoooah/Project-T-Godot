extends CharacterBasic

@export var total_health = 1000
@export var total_mana = 0
@export var health_regen = 1	# every 1000ms
@export var mana_regen = 1		# every 1000ms

@export var attack_damage = 40
@export var ability_power = 0
@export var armor = 0
@export var magic_resist = 0
@export var attack_speed = 0.5
@export var speed = 3
@export var critic_rate = 0		# percentage
@export var critic_damage_rate = 1.5

@export var attack_range = 3
@export var armor_pen = 0
@export var magic_pen = 0

func sub_ready():
	base_stats = CharacterStats.new()
	base_stats.copyFrom(self)
	
func sub_physics_process(_delta):
	pass

func animation():
	var next_anim_state = animator.cur_anim_state
	if attacking:
		next_anim_state = animator.AnimationStatus.ATTACK
	elif velocity == Vector3.ZERO:
		next_anim_state = animator.AnimationStatus.IDLE
	elif velocity.length() <= 5:
		next_anim_state = animator.AnimationStatus.WALK
	elif velocity.length() > 5:
		next_anim_state = animator.AnimationStatus.RUN
	
	if next_anim_state != animator.cur_anim_state:
		animator.cur_anim_state = next_anim_state
		
