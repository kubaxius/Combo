class_name WormSegmentPathFollower extends PathFollow2D

var enabled := false
var segment:WormSegment


func _physics_process(delta: float) -> void:
	if enabled:
		_move(delta)


var distance_traveled = 0
func _move(delta):
	progress = distance_traveled-segment.pixel_position_in_worm
	distance_traveled += segment.current_speed*delta


func _reset_movement():
	distance_traveled = 0


func _ready() -> void:
	var sig:Signal = get_parent().path_changed
	if not sig.is_connected(_reset_movement):
		sig.connect(_reset_movement)
	progress = -segment.pixel_position_in_worm
	enabled = true
	
