@tool
class_name IsPlayerVisible extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard):
	
	if actor.is_player_visible():
		return SUCCESS
	
	return FAILURE
