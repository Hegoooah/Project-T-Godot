extends BaseBuff

class_name OnHitBuff

func apply():
	buff_target.on_hit_buffs[buff_id] = self

# effects that invlove addition operations
func addEffect(damage:DamageCompute, target):
	pass

# effects that involve multiplication operations which should happen
# after all addition effect
func multEffect(damage:DamageCompute, target):
	pass

func expired():
	buff_target.on_hit_buffs.erase(buff_id)
