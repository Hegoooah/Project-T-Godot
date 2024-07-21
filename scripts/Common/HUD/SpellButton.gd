extends Node

@onready var spell_icon = $SpellIcon
@onready var cd_bar = $CDBar
@onready var hot_key = $HotKey
@onready var cd_text = $CD
@onready var casting_bar = $CastingBar

var skill_binding = null
var remain_time = 0		# in ms

func init(hotkey, skill_bind):
	hot_key.text = hotkey
	skill_binding = skill_bind
	
	cd_bar.max_value = skill_binding.cd
	spell_icon.texture_normal = skill_binding.icon
	

func update(cur_time):
	if skill_binding.next_avl_time > cur_time:
		remain_time = skill_binding.next_avl_time - cur_time
	else:
		remain_time = 0
	
	if remain_time < 0:
		remain_time = 0
	
	if remain_time == 0:
		cd_text.text = ""
	else:
		var tmp = remain_time / 1000.0
		cd_text.text = "%3.1f" % tmp
	
	cd_bar.value = remain_time
	
	if skill_binding.casting:
		casting_bar.value = 100
	else:
		casting_bar.value = 0
