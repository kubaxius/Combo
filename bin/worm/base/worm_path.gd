class_name WormPath extends Path2D

@export_range(1, 200) var point_distance:int = 30
@export_range(0, 200) var length_padding:int = 100
@export_node_path("WormHead") var worm_head_path
@onready var worm_head = get_node(worm_head_path)

var path_follower_res = preload("res://worm/base/segment/path_follower.tscn")

var max_length:int

signal path_changed


func _physics_process(_delta: float) -> void:
	_update_path()


func _on_segments_changed(segments_list: WormSegmentsList) -> void:
	_remove_all_followers()
	for segment:WormSegment in segments_list.get_children():
		var path_follower:WormSegmentPathFollower = path_follower_res.instantiate()
		path_follower.segment = segment
		segment.path_follower = path_follower
		add_child(path_follower)
	max_length = segments_list.get_length() + length_padding


func _remove_all_followers():
	for follower:WormSegmentPathFollower in get_children():
		follower.queue_free()


var last_point: Vector2
func _update_path():
	var dist_sq = last_point.distance_squared_to(worm_head.global_position)
	if not dist_sq >= pow(point_distance, 2):
		return
	
	_add_point()
	
	if curve.get_baked_length() > max_length:
		_remove_point()
	path_changed.emit()


func _add_point():
	curve.add_point(worm_head.global_position)
	last_point = worm_head.global_position


func _remove_point():
	curve.remove_point(0)
