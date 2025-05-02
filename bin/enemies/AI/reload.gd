@tool
class_name Reload extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	var anim_tree:AnimationTree = actor.get_node("AnimationTree")
	var state_machine: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
	if state_machine.get_current_node() == "reload":
		return RUNNING
	state_machine.travel("reload")
	return SUCCESS
