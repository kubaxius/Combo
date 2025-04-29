class_name WormSegment extends RigidBody2D

## Distance from the part before.
@export var spacing:int = 31

@onready var part_before:Node2D = get_parent().get_segment_at_position(get_index() - 1)

@onready var state_chart = $StateChart

var current_speed
var pixel_position_in_worm:int
var path_follower:WormSegmentPathFollower
var pull_power = 2.

var is_in_ground:
	get:
		return $StateChart/ParallelState/InGround/Grounded.active


# -------------------------------- #
#        Setters and getters       #
# -------------------------------- #
 
func _set_current_speed(val:float) -> void:
	current_speed = val


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	add_to_group("player")
	input_pickable = false
	_update_pixel_position_in_worm()
	freeze = true
	position.y = pixel_position_in_worm
	_connect_to_preceding()
	freeze = false
	
	var worm:Worm = Utils.get_parent_from_group(self, "worm")
	worm.current_speed_changed.connect(_set_current_speed)
	var segments_list:WormSegmentsList = get_parent()
	segments_list.segments_changed.connect(_on_segments_changed)


# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #

func _on_segments_changed(_segments_list):
	_update_pixel_position_in_worm()


func _on_ground_checker_grounded_state_changed(grounded: bool, _last_ground: Node2D) -> void:
	if grounded:
		state_chart.send_event("segment_entered_ground")
	else:
		state_chart.send_event("segment_exited_ground")


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print_debug(event)


# -------------------------------- #
#          State methods           #
# -------------------------------- #

func _on_grounded_state_entered():
	gravity_scale = 0
	pull_power = 1.


func _on_airborn_state_entered():
	#gravity_scale = 1
	pull_power = 1.


func _on_worm_path_state_physics_processing(_delta: float) -> void:
	_pull_to_point(path_follower.global_position)


func _on_docked_state_entered() -> void:
	input_pickable = true


var dock_path: DockPath
func _on_docked_state_physics_processing(_delta: float) -> void:
	_pull_to_point(dock_path.get_closest_point(global_position))


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

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


func _pull_to_point(point:Vector2) -> void:
	var force = point - global_position
	apply_central_force(force * 100000 * pull_power)


func docked(dock:Path2D):
	dock_path = dock
	$StateChart.send_event("docked")
