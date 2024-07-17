extends BaseBuff

class_name StatsBuff

func apply():
	buff_target.stat_buffs[buff_id] = self
	# when a new stats buff is added, recompute character stats
	buff_target.need_recompute = true

# effects that invlove addition operations
func addEffect(final_stats:CharacterStats):
	pass

# effects that involve multiplication operations which should happen
# after all addition effect
func multEffect(final_stats:CharacterStats):
	pass

func expired():
	buff_target.stat_buffs.erase(buff_id)
	# when an old stats buff is removed, recompute character stats
	buff_target.need_recompute = true
