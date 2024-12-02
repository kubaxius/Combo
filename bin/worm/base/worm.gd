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
		desired_speed = val
		desired_speed_changed.emit(desired_speed)
var turning_speed:float:
	set(val):
		turning_speed = val
		turning_speed_changed.emit(turning_speed)
var is_boosted = false
var is_moving = true

var current_speed:float:
	get():
		return head.velocity.length()

signal desired_speed_changed(new_desired_speed)
signal turning_speed_changed(new_turning_speed)
signal current_speed_changed(new_current_speed)


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	desired_speed = base_speed
	turning_speed = base_turning_speed


func _physics_process(delta: float) -> void:
	current_speed_changed.emit(current_speed)
	#print(Utils.pps_to_kmph(current_speed))


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

func apply_boost() -> void:
	if not is_boosted:
		desired_speed = base_speed * boost_speed_multiplier
		is_boosted = true


func remove_boost() -> void:
	if is_boosted:
		desired_speed = base_speed
		is_boosted = false


func stop_moving() -> void:
	if is_moving:
		desired_speed = 0
		is_moving = false


func start_moving() -> void:
	if not is_moving:
		desired_speed = base_speed
		is_moving = true
