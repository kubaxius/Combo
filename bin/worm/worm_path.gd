class_name WormPath extends Path2D

@export_range(1, 200) var point_distance:int = 30
@export_range(0, 200) var length_padding:int = 100
@export_node_path("WormHead") var worm_head_path
@onready var worm_head = get_node(worm_head_path)

var path_follower_res = preload("res://worm/segments/segment/path_follower.tscn")

var max_length:int

signal path_changed


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	_generate_starting_path()


func _physics_process(_delta: float) -> void:
	_update_path()


# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #

func _on_segments_changed(segments_list: WormSegmentsContainer) -> void:
	_recreate_path_followers(segments_list)


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

func _recreate_path_followers(segments_list: WormSegmentsContainer):
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
	var dist_sq = last_point.distance_squared_to(worm_head.position)
	if not dist_sq >= point_distance * point_distance:
		return
	
	_add_point()
	
	if curve.get_baked_length() > max_length:
		_remove_point()
	path_changed.emit()


func _add_point():
	curve.add_point(worm_head.position)
	last_point = worm_head.position


func _remove_point():
	curve.remove_point(0)


func _generate_starting_path():
	var number_of_points = ceil(float(max_length)/float(point_distance))
	
	for point_id in number_of_points:
		curve.add_point(Vector2i(-point_id*point_distance, 0), Vector2.ZERO, Vector2.ZERO, 0)
