class_name WormHead extends CharacterBody2D

var speed
var desired_movement_vector = Vector2i.UP


func _physics_process(delta: float) -> void:
	if speed:
		move_and_collide(Vector2.UP.rotated(rotation) * speed)
