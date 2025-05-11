@tool
extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	var head: WormHead = actor
	var target:Vector2 = head.target
	
	head.desired_movement_direction =\
	(target - head.global_position).normalized()
	head.desired_speed = head.base_speed
	return SUCCESS
