class_name WormSegment extends RigidBody2D

## Distance from the part before.
@export var spacing:int = 31

@onready var part_before:Node2D = get_parent().get_segment_at_position(get_index() - 1)

var current_speed
var pixel_position_in_worm:int
var path_follower:WormSegmentPathFollower
var pull_power = 2.


func _set_current_speed(val:float) -> void:
	current_speed = val


func _ready() -> void:
	_update_pixel_position_in_worm()
	freeze = true
	position.y = pixel_position_in_worm
	_connect_to_preceding()
	freeze = false
	
	var worm:Worm = Utils.get_parent_from_group(self, "worm")
	worm.current_speed_changed.connect(_set_current_speed)
	var segments_list:WormSegmentsList = get_parent()
	segments_list.segments_changed.connect(_on_segments_changed)


func _physics_process(delta: float) -> void:
	_pull_to_path_follower()


func _on_segments_changed(_segments_list):
	_update_pixel_position_in_worm()


func _connect_to_preceding():
	# if no preceding part, exit
	if not part_before:
		return
	
	$PinJoint2D.node_b = part_before.get_path()


func _update_pixel_position_in_worm() -> void:
	if get_index() == 0:
		pixel_position_in_worm = spacing
		return
	var pos = part_before.pixel_position_in_worm + spacing
	pixel_position_in_worm = pos


func _pull_to_path_follower():
	var force = path_follower.global_position - global_position
	apply_central_force(force * 100000 * pull_power)
