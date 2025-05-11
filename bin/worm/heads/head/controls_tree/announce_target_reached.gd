@tool
extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	print_debug("Target Reached!")
	actor.target_reached.emit(actor.target)
	return SUCCESS
