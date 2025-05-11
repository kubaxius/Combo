@tool
extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	var head: WormHead = actor
	var target:Vector2 = head.target
	
	if head.global_position.distance_to(target) <= head.target_max_acceptable_distance:
		return SUCCESS
	
	return FAILURE
