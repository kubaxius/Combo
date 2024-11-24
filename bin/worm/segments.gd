extends Node2D


func add_segment(segment_res:Resource, index: int = -1):
	var segment:WormSegment = segment_res.instantiate()
	add_child(segment)
	if not index == -1:
		move_child(segment, index)


func get_segment_at_position(index:int):
	if index == -1:
		return %Head.get_child(0)
	
	return get_child(index)
