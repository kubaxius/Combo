class_name WormSegment extends AnimatableBody2D

## Distance from the part before.
@export var spacing:int = 31

var path_follower_res = preload("res://worm/base/segment/path_follower.tscn")
var path_follower: SegmentPathFollower
var worm_path:Path2D
var speed


@onready var part_before: Node2D = get_parent().get_segment_at_position(get_index() - 1)


func _ready() -> void:
	create_path_follower()


func set_variables():
	pass


func create_path_follower():
	path_follower = path_follower_res.instantiate()
	var remote: RemoteTransform2D = path_follower.get_node("RemoteTransform2D")
	remote.remote_path = get_path()
	worm_path.add_child(path_follower)


func update_path_follower():
	path_follower.pixel_position_in_worm = get_pixel_position_in_worm()
	path_follower.speed = speed
	path_follower.part_before = part_before


func get_pixel_position_in_worm():
	if get_index() == 0:
		return spacing
	var segment_before: WormSegment = get_parent().get_segment_at_position(get_index() - 1)
	var pos = segment_before.get_pixel_position_in_worm() + spacing
	return pos
