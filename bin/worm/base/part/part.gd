@tool
class_name WormPart extends Node2D

var worm_path: Path2D
var part_before: WormPart
var first_segment_index: int = 0
var last_segment_index: int:
	get():
		return $Segments.get_child_count() - 1 + first_segment_index
var last_segment: WormSegment:
	get():
		return $Segments.get_child(-1)
var speed: int


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		position_segments()


func setup(p_first_segment_index: int, p_speed: int, p_worm_path:Path2D = null):
	first_segment_index = p_first_segment_index
	speed = p_speed
	worm_path = p_worm_path
	await ready
	segments_setup()


func segments_setup():
	var current_segment_index = first_segment_index
	var segment_before
	if part_before:
		segment_before = part_before.last_segment
	
	for segment:WormSegment in get_children():
		segment.setup(current_segment_index, segment_before, worm_path)
		segment_before = segment
		current_segment_index += 1
	
	last_segment_index = current_segment_index


func position_segments():
	for segment:WormSegment in get_children():
		if  segment.segment_before:
			segment.position.y = segment.segment_before.global_position.y + segment.spacing
		else: 
			segment.position.y = 0
		segment.position.x = 0


func _on_child_entered_tree(node: Node) -> void:
	segments_setup()


func _on_child_exiting_tree(node: Node) -> void:
	segments_setup()
