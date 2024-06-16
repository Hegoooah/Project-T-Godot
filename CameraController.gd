extends Node3D

var player

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	
func _process(delta):
	# global_position = player.global_position
	pass
