class_name Utils extends Node


static func get_named_parent(node:Node, group_name:String) -> Node:
	var parent = node.get_parent()
	
	assert(not parent == null, "Parent with given group not found!")
	if node.is_in_group(group_name):
		return parent
	
	return get_named_parent(parent, group_name)
