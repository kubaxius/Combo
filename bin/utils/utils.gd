class_name Utils extends Node


# -------------------------------- #
#     Parent related functions     #
# -------------------------------- #

static func get_parent_from_group(node:Node, group_name:StringName) -> Node:
	var group = node.get_tree().get_nodes_in_group(group_name)
	
	for possible_parent in group:
		if possible_parent.is_ancestor_of(node):
			return possible_parent
	
	return null


static func get_named_parent(node:Node, group_name:String) -> Node:
	var parent = node.get_parent()
	
	assert(not parent == null, "Parent with given group not found!")
	if node.is_in_group(group_name):
		return parent
	
	return get_named_parent(parent, group_name)


# -------------------------------- #
#           Randomizers            #
# -------------------------------- #

static func get_random_sign(rng:RandomNumberGenerator) -> int:
	var sgn = rng.randi_range(0, 1)
	if sgn == 0:
		sgn = -1
	return sgn


static func get_random_color() -> Color:
	var r = randf_range(0.2, 1)
	var g = randf_range(0.2, 1)
	var b = randf_range(0.2, 1)
	return Color(r, g, b)
