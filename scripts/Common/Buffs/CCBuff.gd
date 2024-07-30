extends BaseBuff

class_name CCBuff

func apply():
	customApply()
	buff_target.simple_timed_buffs[buff_id] = self

func expired():
	customExpire()
	buff_target.simple_timed_buffs.erase(buff_id)

func customApply():
	pass
	
func customExpire():
	pass
