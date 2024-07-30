extends Animator

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

