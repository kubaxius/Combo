class_name WormSegmentsList extends Node2D

signal segments_changed(segments_list:WormSegmentsList)


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	segments_changed.emit(self)


# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #

func _on_child_order_changed() -> void:
	segments_changed.emit(self)


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

func add_segment(segment_res:Resource, index: int = -1):
	var segment:WormSegment = segment_res.instantiate()
	add_child(segment)
	if not index == -1:
		move_child(segment, index)


func get_segment_at_position(index:int):
	if index == -1:
		return %Head
	
	return get_child(index)


func get_length():
	var last_segment:WormSegment = get_child(-1)
	return last_segment.pixel_position_in_worm


func get_segments() -> Array[Node]:
	return get_children()
