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

var gravity:
	get():
		return MeasurementUtils.mps_to_pps(real_gravity)

var base_speed:
	get():
		return MeasurementUtils.kmph_to_pps(real_base_speed)
var base_acceleration:
	get():
		return MeasurementUtils.kmph_to_pps(real_base_acceleration)
var base_deceleration:
	get():
		return MeasurementUtils.kmph_to_pps(real_base_deceleration)

var desired_speed := 0.
var desired_movement_direction := Vector2.RIGHT


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
	
	velocity = velocity.normalized() * (velocity.length() - base_deceleration * delta)


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
