extends CharacterBasic

func animation():
	$AnimationTree.set("parameters/conditions/idle", velocity == Vector3.ZERO)
	$AnimationTree.set("parameters/conditions/run", velocity != Vector3.ZERO)
	
