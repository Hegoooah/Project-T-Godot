extends Node

var myself = null

# Called when the node enters the scene tree for the first time.
func _ready():
	myself = get_parent()
	myself.target_enemy = get_tree().get_nodes_in_group("Player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var nav_pos = myself.target_enemy.position
	myself.nav_agent.target_position = nav_pos
