extends BaseBuff

class_name TimedBuff

func apply():
	buff_target.simple_timed_buffs[buff_id] = self

func expired():
	buff_target.simple_timed_buffs.erase(buff_id)
