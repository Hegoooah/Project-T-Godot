extends CCBuff

class_name KnockUpBuff

var fall_time = 0
var acceleration = 10.0
var start_y_pos = 0

func customInit():
	fall_time = start_time + exist_time / 2
	start_y_pos = buff_target.position.y
	buff_id = 1

func customApply():
	buff_target.interruptAllSpell()
	buff_target.no_move_counter += 1
	buff_target.no_cast_counter += 1
	
func customExpire():
	# make sure when knock up ends, character fall back on ground
	buff_target.velocity.y = -9.8
	buff_target.position.y = start_y_pos
	buff_target.no_move_counter -= 1
	buff_target.no_cast_counter -= 1
	
func per_tick_effect(cur_time, delta):
	if cur_time < fall_time:
		buff_target.position += Vector3.UP * acceleration * delta
	else:
		buff_target.position += Vector3.UP * acceleration * delta * -1
