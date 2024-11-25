class_name SegmentPathFollower extends PathFollow2D

var enabled := false
var pixel_position_in_worm:int
var speed:int

func setup(p_speed:int, p_pixel_position_in_worm:int) -> void:
	speed = p_speed
	pixel_position_in_worm = p_pixel_position_in_worm
	var sig:Signal = get_parent().path_changed
	if not sig.is_connected(reset_movement):
		sig.connect(reset_movement)
	progress = -pixel_position_in_worm
	enabled = true



func _physics_process(delta: float) -> void:
	if enabled:
		move(delta)


var distance_traveled = 0
func move(delta):
	progress = distance_traveled-pixel_position_in_worm
	distance_traveled += speed*delta


func reset_movement():
	distance_traveled = 0
