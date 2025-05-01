@tool
class_name Retreat extends ActionLeaf

@export_range(0, 1000, 5) var safe_distance := 500

func tick(actor: Node, blackboard: Blackboard):
	var scary_thing:Node2D = blackboard.get_value("closest_scary_thing")
	var scary_thing_dist = scary_thing.global_position.distance_to(actor.global_position)
	var scary_thing_direction = sign(scary_thing.global_position.x - actor.global_position.x)
	
	if scary_thing_dist < safe_distance:
		actor.velocity.x = actor.speed * actor.running_speed_mult * -scary_thing_direction
		return RUNNING
	
	actor.velocity.x = 0
	return SUCCESS
