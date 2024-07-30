extends Node

var myself = null
var player = null

var escape_timer = 2000
var escape_recharge = 0
var kite_status = null

enum KITE_STATUS {
	CHASE,
	ESCAPE,
	IDLE,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	myself = get_parent()
	player = get_tree().get_nodes_in_group("Player")[0]
	myself.target_enemy = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	kite(delta)

func kite(delta):
	if kite_status == KITE_STATUS.ESCAPE and escape_timer > 0:
		escape_timer -= delta * 1000
	else:
		escape_recharge += delta * 1000
		if escape_timer <= 0 and escape_recharge > 1000:
			escape_timer = 2000
			escape_recharge = 0
	
	if player.target_enemy == null:
		# player is not trying to attack, chase
		myself.nav_agent.target_position = player.position
	else:
		# player is trying to attack
		var dis = myself.position.distance_to(player.position)
		var my_attack_range = myself.final_stats.attack_range
		if dis < my_attack_range:
			# attack
			myself.nav_agent.target_position = player.position
		else:
			# too far to attack, try escape
			var player_attack_range = player.final_stats.attack_range
			if dis < player_attack_range + 2:
				if escape_timer > 0:
					var dir = player.position.direction_to(myself.position)
					myself.nav_agent.target_position = myself.position + dir * 5
					kite_status = KITE_STATUS.ESCAPE
				else:
					myself.nav_agent.target_position = player.position
			else:
				myself.nav_agent.target_position = myself.position
				
			
			
