class_name SegmentPathFollower extends PathFollow2D

var pixel_position_in_worm
var speed
var part_before: Node2D

func _ready() -> void:
	get_parent().connect("path_changed", reset_movement)
	progress = -pixel_position_in_worm



func _physics_process(delta: float) -> void:
	move_and_rotate()


var distance_traveled = 0
func move_and_rotate():
	progress = distance_traveled-pixel_position_in_worm
	distance_traveled += speed
	look_at(part_before.global_position)
	rotate(0.5*PI)



func reset_movement():
	distance_traveled = 0
