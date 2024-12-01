class_name WormHead extends CharacterBody2D

## set by worm
var speed
var turning_speed

## set by components
#TODO: make it set by signals instead
var desired_movement_vector := Vector2.UP

## in m/s
var gravity = 19.8
var air_resistance = 0.02


func _ready() -> void:
	velocity = Vector2.UP


func _on_grounded_state_entered() -> void:
	pass


func _grounded_state_physics_processing(delta: float) -> void:
	velocity = lerp(velocity.length(), speed, 2.0 * delta) * velocity.normalized()
	var target_angle = lerp_angle(velocity.angle(), desired_movement_vector.angle(), 2.0 * delta)
	velocity = velocity.rotated(target_angle - velocity.angle())


func _airborn_state_physics_processing(delta: float) -> void:
	_apply_gravity(delta)
	_apply_air_resistance(delta)


func _physics_process(delta: float) -> void:
	print(Utils.pps_to_kmph(velocity.length()))
	move_and_slide()
	_look_forward()


func _on_ground_checker_comp_grounded_state_changed(grounded: bool, _last_ground: Node2D) -> void:
	if grounded:
		$PhysicsStateChart.send_event("segment_entered_ground")
	else:
		$PhysicsStateChart.send_event("segment_exited_ground")


func _look_forward() -> void:
	rotation = velocity.angle() + PI/2.


func _apply_gravity(delta: float) -> void:
	velocity.y += Utils.mps_to_pps(gravity) * delta


func _apply_air_resistance(delta: float) -> void:
	velocity *= pow(1. - air_resistance, delta)
