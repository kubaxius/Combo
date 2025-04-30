@tool
class_name IsPlayerSpotted extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard):
	
	if blackboard.get_value("level").player_spotted:
		return SUCCESS
	
	return FAILURE
