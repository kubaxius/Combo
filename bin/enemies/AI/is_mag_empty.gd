@tool
class_name IsMagEmpty extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard):
	if actor.is_mag_empty():
		return SUCCESS
	return FAILURE
