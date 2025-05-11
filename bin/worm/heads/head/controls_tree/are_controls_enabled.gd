@tool
extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	if actor.controls_disabled:
		return FAILURE
	return SUCCESS
