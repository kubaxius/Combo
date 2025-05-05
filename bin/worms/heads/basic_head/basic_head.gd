class_name WormHeadBasic extends CharacterBody2D


@export_custom(PROPERTY_HINT_RANGE, "1,100,1,suffix:km/h") var real_base_speed := 80
var base_speed:
	get():
		return Utils.kmph_to_pps(real_base_speed)


@export_range(1.0, 2.0, 0.1) var boost_value = 1.5
var base_acceleration = Utils.kmph_to_pps(10)
var base_deceleration = Utils.kmph_to_pps(30)
var base_turning_speed = 1
@export var acceleration_curve: Curve
@export var turning_speed_curve: Curve

var desired_speed := 0.
var desired_facing_vector := Vector2.RIGHT


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _physics_process(delta: float) -> void:
	accelerate(delta)
	decelerate(delta)
	turn()
	move_forward()
	print(velocity.length())


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

func accelerate(delta: float):
	
	if velocity.length() >= desired_speed:
		return
	
	if velocity.length() <= 0:
		velocity = Vector2.RIGHT
	
	var acceleration = acceleration_curve.sample(velocity.length() / desired_speed) * base_acceleration * delta
	velocity = velocity.normalized() * (velocity.length() + acceleration)


func decelerate(delta: float):
	if velocity.length() < desired_speed:
		return
	
	if velocity.length() < 3:
		velocity = Vector2.ZERO
	
	velocity = velocity.normalized() * (velocity.length() - base_deceleration * delta)


func move_forward():
	velocity = Vector2.RIGHT.rotated(global_rotation) * velocity.length()
	move_and_slide()


func turn():
	global_rotation = desired_facing_vector.angle()
