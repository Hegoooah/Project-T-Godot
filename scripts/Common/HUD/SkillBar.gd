extends Node

# TODO we need dynamic skill bar size

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var spell_p = $SpellP
@onready var spell_q = $SpellQ
@onready var spell_w = $SpellW
@onready var spell_e = $SpellE
@onready var spell_r = $SpellR

# Called when the node enters the scene tree for the first time.
func _ready():
	spell_p.init("", player.skill_q)
	spell_q.init("Q", player.skill_q)
	spell_w.init("W", player.skill_q)
	spell_e.init("E", player.skill_q)
	spell_r.init("R", player.skill_r)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cur_time = Time.get_ticks_msec()
	spell_p.update(cur_time)
	spell_q.update(cur_time)
	spell_w.update(cur_time)
	spell_e.update(cur_time)
	spell_r.update(cur_time)
