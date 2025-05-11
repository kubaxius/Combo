@tool
extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	var head: WormHead = actor
	var target:Vector2 = head.target
	
	head.desired_speed = 0
	if head.global_position.distance_to(target) > head.target_max_acceptable_distance:
		return RUNNING
	
	return SUCCESS
