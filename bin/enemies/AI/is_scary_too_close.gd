@tool
class_name IsScaryTooClose extends ConditionLeaf

@export_range(0, 1000, 10) var too_close_distance := 200

# TODO: Something funky is going on here.
func tick(actor: Node, blackboard: Blackboard):
	var scary_things = get_tree().get_nodes_in_group("scary")
	
	var closest_scary_thing
	var closest_scary_thing_dist = 99999
	for scary_thing:Node2D in scary_things:
		if not actor.is_node_visible(scary_thing):
			continue
		
		var scary_thing_dist = scary_thing.global_position.distance_to(actor.global_position)
		
		if not scary_thing_dist < too_close_distance:
			continue
		
		if scary_thing_dist < closest_scary_thing_dist:
			closest_scary_thing_dist = scary_thing_dist
			closest_scary_thing = scary_thing
		
	if closest_scary_thing:
		blackboard.set_value("closest_scary_thing", closest_scary_thing)
		return SUCCESS
	
	return FAILURE
