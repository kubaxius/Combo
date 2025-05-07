@tool
class_name SetDesiredMovementDirection extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	
	var mouse_pos: Vector2 = actor.get_global_mouse_position()
	var desired_vector: Vector2 = mouse_pos - actor.global_position
	desired_vector = desired_vector.normalized()
	actor.desired_movement_direction = desired_vector
	return SUCCESS
