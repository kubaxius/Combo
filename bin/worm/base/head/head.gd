class_name WormHead extends CharacterBody2D

## set by worm
var speed
var turning_speed

## set by components
var desired_movement_vector = Vector2.UP


func _physics_process(delta: float) -> void:
	if speed == 0:
		return
	
	rotation = lerp_angle(rotation, desired_movement_vector.angle() + PI/2, delta*turning_speed)
	move_and_collide(Vector2.UP.rotated(rotation) * speed * delta)
