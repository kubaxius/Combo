@tool
class_name IsStopButtonPressed extends ConditionLeaf


func tick(_actor: Node, _blackboard: Blackboard):
	if Input.is_action_pressed("stop_moving"):
		return SUCCESS
	return FAILURE
