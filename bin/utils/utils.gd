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
	var sign = rng.randi_range(0, 1)
	if sign == 0:
		sign = -1
	return sign


static func get_random_color() -> Color:
	var r = randf_range(0.2, 1)
	var g = randf_range(0.2, 1)
	var b = randf_range(0.2, 1)
	return Color(r, g, b)

# -------------------------------- #
#       Velocity conversions       #
# -------------------------------- #


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


static func pps_to_kmph(pps:float) -> float:
	return mps_to_kmph(pps_to_mps(pps))
