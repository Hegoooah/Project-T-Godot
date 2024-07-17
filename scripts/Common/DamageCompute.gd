extends Object

class_name DamageCompute

var base_phy_damage = 0
var base_magic_damage = 0
var base_true_damage = 0

var extra_phy_damage = 0
var extra_magic_damage = 0
var extra_true_damage = 0

var armor_pen = 0	# percentage
var magic_resist_pen = 0	# percentage

var critic_rate = 0
var critic_damage_rate = 1.5
var can_phy_critic = false
var can_magic_critic = false
var can_true_critic = false
var is_critic = false
var extra_crtic_rate = 0
var extra_critic_damage_rate = 0

var source = null
var final_phy_damage = 0
var final_mag_damage = 0
var final_true_damage = 0

var buff_to_enemy = {}

enum DamageType {
	AUTO_ATTACK,
	SPELL,
	ITEM,
	ENV,
	INVALID
}

var damage_type = DamageType.INVALID

func init(phy_d, magic_d, true_d, type:DamageType, source):
	base_phy_damage = phy_d
	base_magic_damage = magic_d
	base_true_damage = true_d
	self.source = source
	damage_type = type
	armor_pen = source.final_stats.armor_pen
	magic_resist_pen = source.final_stats.magic_pen
	critic_rate = source.final_stats.critic_rate
	critic_damage_rate = source.final_stats.critic_damage_rate

func compute_theory_damage(target):
	if damage_type == DamageType.AUTO_ATTACK:
		for buff_id in source.on_hit_buffs:
			source.on_hit_buffs[buff_id].addEffect(self, target)
		for buff_id in source.on_hit_buffs:
			source.on_hit_buffs[buff_id].multEffect(self, target)
	elif damage_type == DamageType.SPELL:
		for buff_id in source.on_cast_hit_buffs:
			source.on_cast_hit_buffs[buff_id].addEffect(self, target)
		for buff_id in source.on_cast_hit_buffs:
			source.on_cast_hit_buffs[buff_id].multEffect(self, target)
	
	# compute if critic
	if can_phy_critic or can_magic_critic or can_true_critic:
		is_critic = randf_range(0, 1) < (critic_rate + extra_crtic_rate) / 100.0
			
func apply_damage(target):
	var armor = target.final_stats.armor * (100.0 - armor_pen) / 100.0
	var magic_resist = target.final_stats.magic_resist * (100.0 - magic_resist_pen) / 100.0
	
	var phy_damage_rate = 100.0 / (100.0 + armor)
	var mag_damage_rate = 100.0 / (100.0 + magic_resist)
	
	final_phy_damage = compute_partial_final_damage(base_phy_damage, extra_phy_damage, can_phy_critic, phy_damage_rate)
	final_mag_damage = compute_partial_final_damage(base_magic_damage, extra_magic_damage, can_magic_critic, mag_damage_rate)
	final_true_damage = compute_partial_final_damage(base_true_damage, extra_true_damage, can_true_critic, 1.0)
	
	target.takeDamage(self)
	

func compute_partial_final_damage(base_damage, extra_damage, can_critic, damage_rate):
	var final_damage = extra_damage
	if can_critic and is_critic:
		final_damage += base_damage * (critic_damage_rate + extra_critic_damage_rate)
	else:
		final_damage += base_damage
	return final_damage * damage_rate
	
