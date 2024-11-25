class_name WormHead extends CharacterBody2D

var speed
var desired_movement_vector = Vector2.UP


func _physics_process(delta: float) -> void:
	if speed:
		rotation = lerp_angle(rotation, desired_movement_vector.angle() + PI/2, delta)
		move_and_collide(Vector2.UP.rotated(rotation) * speed)
