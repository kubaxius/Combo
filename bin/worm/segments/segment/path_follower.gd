class_name WormSegmentPathFollower extends PathFollow2D

var enabled := false
var segment:WormSegment
@onready var worm_controller:WormController = get_tree().get_nodes_in_group("worm_controller")[0]

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
	distance_traveled += worm_controller.velocity.length()*delta


func _reset_movement():
	distance_traveled = 0
