@tool
class_name WormSegment extends Node2D

## Distance from the part before.
@export var spacing:int = 31

var worm_path:Path2D
var index:int = 0
var segment_before:WormSegment


func setup(index:int, p_segment_before:WormSegment, p_worm_path:Path2D = null):
	worm_path = p_worm_path
	segment_before = p_segment_before
	await ready
	if has_node("PathFollowerComponent"):
		$PathFollowerComponent.setup(worm_path)
