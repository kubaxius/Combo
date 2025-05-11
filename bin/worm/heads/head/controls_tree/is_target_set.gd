@tool
extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	if actor.target:
		return SUCCESS
	return FAILURE
