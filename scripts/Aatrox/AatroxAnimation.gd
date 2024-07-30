extends Animator

enum AnimationStatus {
	IDLE,
	WALK,
	ATTACK,
	CHARGE,
	CAST_Q_1,
	CAST_Q_2,
	CAST_Q_3,
	CAST_W,
	CAST_E,
	CAST_R,
	CAST_Q_1_TO_WALK,
	CAST_Q_2_TO_WALK,
	CAST_Q_3_TO_WALK,
	CAST_Q_1_TO_IDLE,
	CAST_Q_2_TO_IDLE,
	CAST_Q_3_TO_IDLE,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_anim_state = AnimationStatus.IDLE



	
