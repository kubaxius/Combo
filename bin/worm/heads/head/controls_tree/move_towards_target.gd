@tool
extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	var head: WormHead = actor
	var target:Vector2 = head.target
	
	if head.global_position.distance_to(target) > head.get_breaking_distance():
		return RUNNING
	
	return SUCCESS
