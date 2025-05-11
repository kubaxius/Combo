@tool
extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	var desired_speed: float = actor.base_speed
	
	if Input.is_action_pressed("boost"):
		desired_speed *= actor.boost_value
	
	actor.desired_speed = desired_speed
	return SUCCESS
