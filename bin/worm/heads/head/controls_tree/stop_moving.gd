@tool
extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	actor.desired_speed = 0
	return SUCCESS
