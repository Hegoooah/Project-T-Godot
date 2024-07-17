extends Node

var cur_anim_state = null

enum AnimationStatus {
	IDLE,
	WALK,
	RUN,
	ATTACK,
	CHARGE,
	CAST_Q,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_anim_state = AnimationStatus.IDLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
