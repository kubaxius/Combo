class_name SegmentPathFollower extends PathFollow2D

var enabled := false
var pixel_position_in_worm:int
var speed:int

func setup(p_speed:int, p_pixel_position_in_worm:int) -> void:
	speed = p_speed
	pixel_position_in_worm = p_pixel_position_in_worm
	get_parent().connect("path_changed", reset_movement)
	progress = -pixel_position_in_worm
	enabled = true



func _physics_process(delta: float) -> void:
	if enabled:
		move()


var distance_traveled = 0
func move():
	progress = distance_traveled-pixel_position_in_worm
	distance_traveled += speed


func reset_movement():
	distance_traveled = 0
