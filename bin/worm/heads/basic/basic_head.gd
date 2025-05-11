class_name WormHead extends CharacterBody2D


@export_custom(PROPERTY_HINT_RANGE, "1,100,1,suffix:km/h") var real_base_speed := 80
@export_range(1.0, 2.0, 0.1) var boost_value = 1.5
## This gets multiplied by Acceleration Curve relative to max speed.
@export_custom(PROPERTY_HINT_RANGE, "1,100,1,suffix:km/h/s") var real_base_acceleration := 20
## This is used as is.
@export_custom(PROPERTY_HINT_RANGE, "1,100,1,suffix:km/h/s") var real_base_deceleration := 30
@export var acceleration_curve: Curve
@export var turning_speed_curve: Curve
## The percentage of the turn that the worm will make in one second.
@export var base_turning_speed = 2
@export_range(0, 1, 0.1) var turning_speed_multiplier_while_airborn := 0.2
@export_custom(PROPERTY_HINT_RANGE, "1,50,0.1,suffix:m/s/s") var real_gravity := 9.8

# TODO: Make mass increase the more segments there is. Also, make it harder
# to accelerate and decelerate based on mass. 

var gravity:
	get():
		return MeasurementUtils.mps_to_pps(real_gravity)

var base_speed:
	get():
		return MeasurementUtils.kmph_to_pps(real_base_speed)
var base_acceleration:
	get():
		return MeasurementUtils.kmph_to_pps(real_base_acceleration)
var deceleration:
	get():
		return MeasurementUtils.kmph_to_pps(real_base_deceleration)

var desired_speed := 0.
var desired_movement_direction := Vector2.RIGHT

# If set and the controls are disabled, the head will try to move into 
# this position in a straight line.
var target: Vector2 = Vector2(0, 0)
var target_max_acceptable_distance := 100

var controls_disabled = false

@onready var state_chart:StateChart = %StateChart

# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	set_initial_state()


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _physics_process(_delta: float) -> void:
	move_and_slide()
	look_where_you_move()


# -------------------------------- #
#          State methods           #
# -------------------------------- #

func _on_grounded_state_physics_processing(delta: float) -> void:
	recalculate_velocity(delta, true)


func _on_airborne_state_physics_processing(delta: float) -> void:
	recalculate_velocity(delta, false)
	velocity = PhysicsUtils.apply_air_drag(velocity, delta)


func _on_dock_scene_state_physics_processing(delta: float) -> void:
	recalculate_velocity(delta, true)


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

func accelerate(delta: float):
	
	if velocity.length() >= desired_speed:
		return
	
	if velocity.length() <= 0:
		velocity = Vector2.from_angle(global_rotation)
	
	var acceleration = base_acceleration * delta * acceleration_curve\
	.sample(MeasurementUtils.pps_to_kmph(velocity.length()))
	
	velocity = velocity.normalized() * (velocity.length() + acceleration)


func decelerate(delta: float):
	if velocity.length() < desired_speed:
		return
	
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	
	velocity = velocity.normalized() * (velocity.length() - deceleration * delta)


func get_new_velocity_angle(delta: float, grounded: bool) -> float:
	var angle_step = delta * base_turning_speed * turning_speed_curve\
		.sample(MeasurementUtils.pps_to_kmph(velocity.length()))
	
	# TODO: Make it so that you can turn harder the more your desired angle
	# is aligned with gravity Vector.
	if not grounded:
		angle_step *= turning_speed_multiplier_while_airborn
	
	var new_angle :=\
		lerp_angle(velocity.angle(),\
		desired_movement_direction.angle(),\
		angle_step)
	
	return new_angle


func recalculate_velocity(delta: float, grounded: bool):
	accelerate(delta)
	decelerate(delta)
	
	var new_angle = get_new_velocity_angle(delta, grounded)
	
	velocity = Vector2.from_angle(new_angle) * velocity.length()
	
	if not grounded:
		apply_gravity(delta)


func apply_gravity(delta: float):
	velocity += Vector2.DOWN * gravity * delta


func look_where_you_move():
	if velocity.length() <= 0:
		return
	global_rotation = velocity.angle()


func get_breaking_distance() -> float:
	var current_speed = velocity.length()
	if current_speed < 1:
		return 0
	
	return (current_speed * current_speed) / (2 * deceleration)



func set_initial_state():
	var main_scene:Node2D = get_tree().current_scene
	
	if main_scene.is_in_group("dock_scene"):
		%IsInGroundComponent.reactive = false
		state_chart.call_deferred("send_event", "to_dock_scene")
		return
	
	var in_ground:bool = %IsInGroundComponent.is_in_ground()
	
	if in_ground:
		state_chart.send_event("entered_ground")
	else:
		state_chart.send_event("exited_ground")
