extends Object

# this is a scripltable class
class_name CharacterStats

var total_health = 100
var total_mana = 100
var health_regen = 1	# every 1000ms
var mana_regen = 1		# every 1000ms

var attack_damage = 40
var ability_power = 0
var armor = 30
var magic_resist = 30
var attack_speed = 0.5
var speed = 3
var critic_rate = 0		# percentage
var critic_damage_rate = 1.5

var attack_range = 3
var armor_pen = 0
var magic_pen = 0

var fall_acceleration = 1000

func copyFrom(source):
	total_health = source.total_health
	total_mana = source.total_mana
	health_regen = source.health_regen
	mana_regen = source.mana_regen
	
	attack_damage = source.attack_damage
	ability_power = source.ability_power
	armor = source.armor
	magic_resist = source.magic_resist
	attack_speed = source.attack_speed
	speed = source.speed
	critic_rate = source.critic_rate
	critic_damage_rate = source.critic_damage_rate
	
	attack_range = source.attack_range
	armor_pen = source.armor_pen
	magic_pen = source.magic_pen
