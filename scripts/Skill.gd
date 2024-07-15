extends Node

class_name BaseSkill

var cd = 10 * 1000 # cd in ms
var next_avl_time = 0 # next avaliable time in ms
var targets = null # space to store targets if necessary

var casting = false
var caster : CharacterBasic = null

enum {
	SKILL_NOT_READY,
	INVALID_TARGET,
	SKILL_CAST_SUCCESS
}

func getRemainTime():
	var cur_time = Time.get_ticks_msec()
	var remain = next_avl_time - cur_time
	return max(remain, 0)
	
func isReady():
	return (Time.get_ticks_msec() > next_avl_time) and !casting
	
func cast(_source, _dest):
	pass
	
func isTargetValid(_target):
	pass

func process(_delta):
	pass
