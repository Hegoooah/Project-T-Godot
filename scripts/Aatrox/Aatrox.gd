extends CharacterBasic

@export var total_health := 1000
@export var total_mana := 0
@export var health_regen := 1	# every 1000ms
@export var mana_regen := 1		# every 1000ms

@export var attack_damage := 100
@export var ability_power := 0
@export var armor := 0
@export var magic_resist := 0
@export var attack_speed := 0.5
@export var speed := 3
@export var critic_rate := 0		# percentage
@export var critic_damage_rate := 1.5

@export var attack_range := 3
@export var armor_pen := 0
@export var magic_pen := 0

@onready var q1_area_inner := $QArea/Q1CollisionInner
@onready var q1_area_outer := $QArea/Q1CollisionOuter
@onready var q2_area_inner := $QArea/Q2CollisionInner
@onready var q2_area_outer := $QArea/Q2CollisionOuter
@onready var q3_area_inner := $QArea/Q3CollisionInner
@onready var q3_area_outer := $QArea/Q3CollisionOuter

@onready var q1_indicator := $QIndicator/Q1
@onready var q2_indicator := $QIndicator/Q2
@onready var q3_indicator := $QIndicator/Q3

func sub_ready():
	att_pre_anim_time = 500
	att_full_time = 650
	base_stats = CharacterStats.new()
	base_stats.copyFrom(self)
	
	skill_q = AatroxQ.new()
	skill_q.register(self)
	
	skill_e = AatroxE.new()
	skill_e.register(self)
	
func sub_physics_process(_delta):
	pass

func animation():
	var next_anim_state = animator.cur_anim_state
	if attacking:
		next_anim_state = animator.AnimationStatus.ATTACK
	elif velocity == Vector3.ZERO:
		next_anim_state = animator.AnimationStatus.IDLE
	else:
		next_anim_state = animator.AnimationStatus.WALK

	if next_anim_state != animator.cur_anim_state:
		animator.softChangeState(next_anim_state)
		
