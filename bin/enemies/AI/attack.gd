@tool
extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard):
	actor.modulate.r = 1.
	actor.modulate.g = 0.
	actor.modulate.b = 0.
	return SUCCESS
