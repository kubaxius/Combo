class_name IsPlayerDetected extends ConditionLeaf


func _tick(actor: Node, blackboard: Blackboard):
	if actor.player_detected:
		return SUCCESS
	return FAILURE
