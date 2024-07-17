extends Object

class_name BaseBuff

enum BuffType {
	ON_HIT_BUFF,
	ON_CAST_HIT_BUFF,
	STATS_BUFF,
	TIMED_BUFF,
	ON_DAMAGED_BUFF,
	INVALID_BUFF_TYPE
}

var buff_id = 0
var type = BuffType.INVALID_BUFF_TYPE

var is_expire = false
var start_time = 0	# in ms
var exist_time = 0	# in ms
var end_time = 0	# in ms

var buff_source = null
var buff_target = null

func init(duration, source, target):
	buff_source = source
	exist_time = duration
	start_time = Time.get_ticks_msec()
	end_time = start_time + exist_time
	buff_target = target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_expire:
		return
	var cur_time = Time.get_ticks_msec()
	if cur_time > end_time:
		is_expire = true
		expired()
		return
	
	# buff still in effect
	per_tick_effect()
	
func per_tick_effect():
	pass

func apply():
	pass

# when a buff expired, remove itself from the buff list
func expired():
	pass
