#@tool
extends Node2D

var segment_res = preload("res://worm/segment.tscn")

@export_node_path var preceding_part_path:
	get():
		if preceding_part_path:
			return get_node(preceding_part_path).get_path()
@export_range(0, 100) var segment_spacing:int = 24
@export_range(1, 20) var length:int = 0

func _ready() -> void:
	change_length()
	change_spacing()

func change_length():
	var old_length = $Segments.get_child_count()
	var new_length = length
	if old_length > new_length:
		for i in old_length-new_length:
			remove_segment()
	
	if new_length > old_length:
		for i in new_length-old_length:
			add_segment()

func add_segment():
	var segment_instance:WormSegment = segment_res.instantiate()
	$Segments.add_child(segment_instance)
	change_spacing()
	if $Segments.get_child_count() > 1:
		segment_instance.preceding_part_path = $Segments.get_child(-2).get_path()
	elif preceding_part_path:
		segment_instance.preceding_part_path = preceding_part_path

func remove_segment():
	var last_segment = $Segments.get_child(-1)
	$Segments.remove_child(last_segment)
	last_segment.queue_free()

func change_spacing():
	for i in $Segments.get_child_count():
		var segment:WormSegment = $Segments.get_child(i)
		segment.freeze = true
		segment.position.y = i * segment_spacing
		segment.linear_velocity = Vector2.ZERO
		segment.freeze = false

func _physics_process(delta: float) -> void:
	pass
