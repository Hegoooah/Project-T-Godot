extends BaseBuff

class_name OnDamagedBuff

func apply():
	buff_target.on_damaged_buffs[buff_id] = self
	
	
# effects that invlove addition operations
func addEffect(damage:DamageCompute):
	pass

# effects that involve multiplication operations which should happen
# after all addition effect
func multEffect(damage:DamageCompute):
	pass

func expired():
	buff_target.on_damaged_buffs.erase(buff_id)
