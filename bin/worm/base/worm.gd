class_name Worm extends Node2D

## Expressed in km/h.
@export_custom(PROPERTY_HINT_RANGE, "1,200,1,suffix:km/h") var real_base_speed := 50.
## Expressed in km/h/s.
@export_custom(PROPERTY_HINT_RANGE, "1,20,0.1,suffix:km/h/s") var real_boost_component := 20.
@export_custom(PROPERTY_HINT_RANGE, "50,300,0.5,suffix:km/h") var real_max_speed := 150.
@export_range(0.1, 1, 0.1) var acceleration := 0.5
@export_range(1, 2, 0.1) var base_turning_speed := 1.

## Used when worm has to follow something that is not mouse.
@export_node_path("Node2D") var node_to_follow

@onready var head:WormHead = %Head
@onready var worm_path:WormPath = %Path
@onready var segments_list:WormSegmentsList = %SegmentsList
@onready var state_chart:StateChart = $StateChart

# in px/s
var base_speed:float:
	get():
		return Utils.kmph_to_pps(real_base_speed)
# The speed the worm will try to achieve. Boosting and stoping will change it.
# Won't exceed max_speed.
var desired_speed:float:
	set(val):
		val = clamp(val, 0, max_speed)
		if desired_speed != val:
			desired_speed = val
			desired_speed_changed.emit(desired_speed)
# in px/s
var max_speed:float:
	get():
		return Utils.kmph_to_pps(real_max_speed)
# in px/s/s
var boost_component:float:
	get():
		return Utils.kmph_to_pps(real_boost_component)
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
	#if node_to_follow:
		#get_node(node_to_follow).finished.connect(_docked)
	desired_speed = base_speed
	turning_speed = base_turning_speed


func _physics_process(_delta: float) -> void:
	current_speed_changed.emit(current_speed)


# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #

func _on_head_entered_ground() -> void:
	pass


func _on_head_exited_ground() -> void:
	state_chart.send_event("boost_off")


# -------------------------------- #
#          State methods           #
# -------------------------------- #


func on_inactive_state_entered():
	desired_speed = 0


func _on_follow_mouse_state_physics_processing(_delta: float) -> void:
	if $FollowMouse.vector_to_mouse:
		desired_direction = $FollowMouse.vector_to_mouse


func _on_follow_node_state_physics_processing(_delta: float) -> void:
	var node:Node2D = get_node(node_to_follow)
	desired_direction = head.global_position.direction_to(node.global_position)
	var dist = head.global_position.distance_to(node.global_position)
	desired_speed = base_speed
	turning_speed = 2.


func _on_boosted_state_physics_processing(delta: float) -> void:
	desired_speed += boost_component * delta


func _on_not_boosted_state_entered() -> void:
	desired_speed = base_speed


func _on_not_moving_state_physics_processing(_delta: float) -> void:
	desired_speed = 0


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #


func _docked():
	state_chart.send_event("deactivate")
