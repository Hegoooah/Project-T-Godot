extends Node

class_name Animator

var cur_anim_state = null
var next_state = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if next_state != null:
		cur_anim_state = next_state
		next_state = null

func softChangeState(new_state):
	if next_state == null:
		next_state = new_state

func hardChangeState(new_state):
	next_state = new_state
