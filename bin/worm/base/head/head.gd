class_name WormHead extends CharacterBody2D

## set by worm
var desired_speed:float: set = set_desired_speed
var acceleration:float = 2.0
var turning_speed:float = 2.0
var desired_movement_vector := Vector2.UP

## in m/s
var gravity = 29.8
var air_resistance = 0.01

@onready var state_chart = $StateChart

signal entered_ground
signal exited_ground

# -------------------------------- #
#        Setters and getters       #
# -------------------------------- #

func set_desired_speed(val:float):
	desired_speed = val


func set_acceleration(val:float):
	acceleration = val


func set_turning_speed(val:float):
	turning_speed = val


func set_desired_movement_vector(val:Vector2):
	desired_movement_vector = val


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- # 

func _ready() -> void:
	var worm:Worm = Utils.get_parent_from_group(self, "worm")
	if worm:
		worm.desired_speed_changed.connect(set_desired_speed)
		worm.turning_speed_changed.connect(set_turning_speed)
		worm.desired_direction_changed.connect(set_desired_movement_vector)


func _physics_process(_delta: float) -> void:
	move_and_slide()
	_look_forward()
	# TODO: use this to setup collision with enemies
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * 100)


# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #

func _on_ground_checker_grounded_state_changed(grounded: bool, _last_ground: Node2D) -> void:
	if grounded:
		state_chart.send_event("segment_entered_ground")
	else:
		state_chart.send_event("segment_exited_ground")


func _on_mouth_body_entered(body: Node2D) -> void:
	if body.is_in_group("eatable") and body.has_method("got_eaten"):
		body.got_eaten()


# -------------------------------- #
#          State methods           #
# -------------------------------- #


func _entered_grounded_state() -> void:
	entered_ground.emit()


func _entered_airborn_state() -> void:
	exited_ground.emit()


func _grounded_state_physics_processing(delta: float) -> void:
	_move_and_turn(delta)


func _airborn_state_physics_processing(delta: float) -> void:
	_apply_gravity(delta)
	_apply_air_resistance(delta)
	_turn(delta, 0.3)


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

func _look_forward() -> void:
	if velocity != Vector2.ZERO:
		global_rotation = velocity.angle() + PI/2.


func _apply_gravity(delta: float) -> void:
	velocity.y += Utils.mps_to_pps(gravity) * delta


func _apply_air_resistance(delta: float) -> void:
	velocity *= pow(1. - air_resistance, delta)


func _move_and_turn(delta) -> void:
	# fix the edgecase where velocity is 0
	if desired_speed > 0.0001 and velocity.length() == 0:
		velocity = Vector2.UP.rotated(global_rotation)
	
	# accelerate worm towards desired velocity
	velocity = lerp(velocity.length(), desired_speed, acceleration * delta) * velocity.normalized()
	_turn(delta)


func _turn(delta:float, strength:float = 1.0) -> void:
	# turn the head in the desired direction
	var target_angle = lerp_angle(velocity.angle(), desired_movement_vector.angle(), turning_speed * delta * strength)
	velocity = velocity.rotated(target_angle - velocity.angle())
