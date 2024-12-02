class_name Utils extends Node


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


# -------------------
# Velocity Conversions
# -------------------

const pixels_per_meter = 25.


static func kmph_to_mps(kmph:float) -> float:
	return kmph * 5. / 18.


static func mps_to_pps(mps:float) -> float:
	return mps * pixels_per_meter


static func kmph_to_pps(kmph:float) -> float:
	return mps_to_pps(kmph_to_mps(kmph))


static func pps_to_mps(pps:float) -> float:
	return pps/pixels_per_meter


static func mps_to_kmph(mps:float) -> float:
	return mps * 18. / 5.


static func pps_to_kmph(pps:float, pixels_per_meter:float = 25) -> float:
	return mps_to_kmph(pps_to_mps(pps))
