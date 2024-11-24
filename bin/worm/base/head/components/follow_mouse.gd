extends Node2D

@export var speed = 10

@onready var parent: CharacterBody2D = get_parent()

var direction_vector = Vector2.ZERO
func _physics_process(delta: float) -> void:
	parent.move_and_collide(Vector2.UP.rotated(parent.rotation) * speed)
	var mouse_pos = get_global_mouse_position()
	var angle_to_mouse = parent.global_position.direction_to(mouse_pos).angle() + PI/2
	parent.rotation = lerp_angle(parent.rotation, angle_to_mouse, delta)
	
