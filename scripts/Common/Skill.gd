extends Object

class_name BaseSkill

var cd = 10 * 1000 # cd in ms
var next_avl_time = 0 # next avaliable time in ms
var targets = null # space to store targets if necessary

var casting = false
var caster : CharacterBasic = null

enum Skill_Status {
	SKILL_NOT_READY,
	INVALID_TARGET,
	SKILL_CAST_SUCCESS
}

func register(source):
	caster = source

func getRemainTime():
	var cur_time = Time.get_ticks_msec()
	var remain = next_avl_time - cur_time
	return max(remain, 0)
	
func isReady():
	return (Time.get_ticks_msec() > next_avl_time) and !casting and caster.can_cast
	
func cast(_dest):
	pass
	
func isTargetValid(_target):
	pass

func process(_delta):
	pass
