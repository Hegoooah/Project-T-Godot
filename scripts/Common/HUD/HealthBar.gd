extends Node

@onready var bar = get_node("SubViewport/Panel/ProgressBar")

var character = null

func _ready():
	character = get_parent()
	
func updateBar():
	bar.max_value = character.final_stats.total_health
	bar.value = character.cur_health
