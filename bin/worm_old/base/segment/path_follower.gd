class_name WormSegmentPathFollower extends PathFollow2D

var enabled := false
var segment:WormSegment

# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #
 
func _ready() -> void:
	var sig:Signal = get_parent().path_changed
	sig.connect(_on_path_changed)
	progress = -segment.pixel_position_in_worm
	enabled = true


func _physics_process(delta: float) -> void:
	if enabled:
		_move(delta)


# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #
 
func _on_path_changed() -> void:
	_reset_movement()


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #
 
var distance_traveled = 0
func _move(delta):
	progress = distance_traveled-segment.pixel_position_in_worm
	distance_traveled += segment.current_speed*delta


func _reset_movement():
	distance_traveled = 0
