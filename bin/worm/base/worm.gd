class_name Worm extends Node2D

## Expressed in km/h.
@export_custom(PROPERTY_HINT_RANGE, "1,200,1,suffix:km/h") var real_base_speed := 50.
@export_range(0.1, 1, 0.1) var acceleration := 0.5
@export_range(1, 2, 0.1) var base_turning_speed := 1.
@export_range(1, 10, 0.1) var boost_speed_multiplier := 2.

@onready var head:WormHead = %Head
@onready var worm_path:WormPath = %Path
@onready var segments_list:WormSegmentsList = %SegmentsList

# in px/s
var base_speed:float:
	get():
		return Utils.kmph_to_pps(real_base_speed)
var desired_speed:float:
	set(val):
		if desired_speed != val:
			desired_speed = val
			desired_speed_changed.emit(desired_speed)
var turning_speed:float:
	set(val):
		turning_speed = val
		turning_speed_changed.emit(turning_speed)
var desired_direction:Vector2:
	set(val):
		desired_direction = val
		desired_direction_changed.emit(desired_direction)


var current_speed:float:
	get():
		return head.velocity.length()

signal desired_speed_changed(new_value:float)
signal turning_speed_changed(new_value:float)
signal current_speed_changed(new_value:float)
signal desired_direction_changed(new_value:Vector2)

# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	desired_speed = base_speed
	turning_speed = base_turning_speed


func _physics_process(_delta: float) -> void:
	current_speed_changed.emit(current_speed)
	if $FollowMouse.vector_to_mouse:
		desired_direction = $FollowMouse.vector_to_mouse
	#print(Utils.pps_to_kmph(current_speed))


# -------------------------------- #
#          State methods           #
# -------------------------------- #

func _on_boosted_state_physics_processing(_delta: float) -> void:
	desired_speed = base_speed * boost_speed_multiplier


func _on_not_boosted_state_physics_processing(_delta: float) -> void:
	desired_speed = base_speed


func _on_not_moving_state_physics_processing(_delta: float) -> void:
	desired_speed = 0
